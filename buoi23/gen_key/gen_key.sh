#!/bin/bash

# Source configuration
source config.sh

# # Ensure necessary directories exist
# mkdir -p "$(dirname "$KEY_FILE")"
# mkdir -p "$(dirname "$CSR_FILE")"
# mkdir -p "$(dirname "$CERT_FILE")"
# mkdir -p "$(dirname "$PKCS12_FILE")"
# mkdir -p "$(dirname "$CONNECTOR_PKCS12_FILE")"
# mkdir -p "$(dirname "$CONNECTOR_CERT_FILE")"
# mkdir -p "$(dirname "$TRUSTSTORE_FILE")"
# mkdir -p "$(dirname "$PUBLIC_KEY_FILE")"
# # Generate a private key
# # Generate a private key
# openssl genrsa -out $KEY_FILE 2048

# # Generate a Certificate Signing Request
# openssl req -new -sha256 -key $KEY_FILE -out $CSR_FILE 

# # Generate a self-signed x509 certificate
# openssl req -x509 -sha256 -days 365 -key $KEY_FILE -in $CSR_FILE -out $CERT_FILE

# # Create SSL identity file in PKCS12 format
# openssl pkcs12 -export -out $CLIENT_IDENTITY_P12 -inkey $KEY_FILE -in $CERT_FILE -name $ALIAS

# # Create connectorC PKCS12 file
# openssl pkcs12 -export -in $CERT_FILE -out $CONNECTOR_C_P12 -inkey $KEY_FILE -name $ALIAS

# # Copy the certificate to connectorC.cert
# cp $CERT_FILE $CONNECTOR_C_CERT

# # Import the private key and certificate into the keystore
# openssl pkcs12 -export -inkey $KEY_FILE -in $CERT_FILE -out $CONNECTOR_C_P12 -name $ALIAS

# keytool -importkeystore -deststorepass $PASSWORD -destkeystore $TRUSTSTORE_P12 -srckeystore $CONNECTOR_C_P12 -srcstoretype PKCS12 -srcstorepass $PASSWORD -alias $ALIAS

# keytool -import -alias daps-$ALIAS -file daps.cert -storetype PKCS12 -keystore $TRUSTSTORE_P12

# # Export the public key
# openssl rsa -in $KEY_FILE -pubout -out $PUBLIC_KEY_FILE

# echo "All operations completed successfully."

#!/bin/bash

# Load config values
source config.sh

#!/bin/bash

# Load config values
source config.sh

# Ensure necessary directories exist
mkdir -p "$(dirname "$KEY_FILE")"
mkdir -p "$(dirname "$CSR_FILE")"
mkdir -p "$(dirname "$CERT_FILE")"
mkdir -p "$(dirname "$PKCS12_FILE")"
mkdir -p "$(dirname "$CA_KEY")"
mkdir -p "$(dirname "$CA_CERT")"

# 1. Generate the root CA private key
openssl genrsa -out $CA_KEY 4096

# 2. Create the root CA certificate
openssl req -x509 -new -nodes -key $CA_KEY -sha256 -days 3650 -out $CA_CERT -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONAL_UNIT/CN=$CA_COMMON_NAME/emailAddress=$EMAIL"

# 3. Generate the server private key
openssl genrsa -out $KEY_FILE 2048

# 4. Create an OpenSSL configuration file for certificate extensions (for AKI and SKI)
cat > openssl_ext.cnf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = $COUNTRY
ST = $STATE
L = $LOCALITY
O = $ORGANIZATION
OU = $ORGANIZATIONAL_UNIT
CN = $COMMON_NAME
emailAddress = $EMAIL

[ req_ext ]
subjectKeyIdentifier = hash
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = $COMMON_NAME

[ v3_req ]
authorityKeyIdentifier = keyid,issuer
subjectKeyIdentifier = hash
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

EOF

# 5. Generate a Certificate Signing Request (CSR) for the server certificate
openssl req -new -sha256 -key $KEY_FILE -out $CSR_FILE -config openssl_ext.cnf

# 6. Sign the server certificate with the root CA and add AKI and SKI
openssl x509 -req -in $CSR_FILE -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial \
-out $CERT_FILE -days 365 -sha256 -extfile openssl_ext.cnf -extensions v3_req

# 7. Create SSL identity file in PKCS12 format
openssl pkcs12 -export -out $PKCS12_FILE -inkey $KEY_FILE -in $CERT_FILE -name $ALIAS -passout pass:$PASSWORD


# 8. Export the public key
openssl rsa -in $KEY_FILE -pubout -out $PUBLIC_KEY_FILE

# 9. Create a Truststore (PKCS12 format) and import the root CA certificate
keytool -importcert -trustcacerts -file $CA_CERT -alias root-ca -keystore $TRUSTSTORE_FILE -storepass $PASSWORD -noprompt

# 10. Optionally, import the DAPS certificate (or any other trusted certificates) into the truststore
# If you have the DAPS certificate as daps.cert, you can import it like this:
keytool -importcert -trustcacerts -file daps.cert -alias daps-cert -keystore $TRUSTSTORE_FILE -storepass $PASSWORD -noprompt

# add Cert A xoa chi de test thu
# keytool -importcert -trustcacerts -file connectorA.cert -alias connectora-cert -keystore $TRUSTSTORE_FILE -storepass $PASSWORD -noprompt


# 9. Clean up
rm -f openssl_ext.cnf

# Print success message
echo "Root CA, server key, CSR, and certificate with AKI/SKI generated successfully."

