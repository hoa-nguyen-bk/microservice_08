# buổi 23

- anh Bình chỉ cho các log đo time để 

```ssh
openssl req -x509 -newkey rsa:2048 \
  -keyout gateway-bookshop.key \
  -out gateway-bookshop.crt \
  -days 365 \
  -nodes \
  -subj "/C=VN/ST=HCM/L=HCM/O=IVB/OU=IT/CN=api-admin-bookshop"
```
- file private key quan trọng nhẩt ko để mất nó, mất thì cái cert ko còn quan trọng nữa


- sinh file b12 từ file private key và cert của mình
```
openssl pkcs12 -export   -in gateway-bookshop.crt   -inkey gateway-bookshop.key   -out keystore-gateway-bookshop.p12   -name gateway-bookshop -passout pass:cybersoft123
```

- cách sinh file phải nhớ, vì trong mô hình mình học á, vì nếu triển khai trong môi trường nội bộ mà nó iu cầu ssa thì phải xài cs-ca là chủ yếu, và mình phải xài cái này, 

## authen

```ssh
openssl req -x509 -newkey rsa:2048 \
  -keyout authen-bookshop.key \
  -out authen-bookshop.crt \
  -days 365 \
  -nodes \
  -subj "/C=VN/ST=HCM/L=HCM/O=IVB/OU=IT/CN=local"
```

```
openssl pkcs12 -export   -in bookshop-authen.crt   -inkey bookshop-authen.key   -out bookshop-authen.p12   -name authen -passout pass:cybersoft123
```

- classpath dùng để xài nội bộ ở đây thui, // , lên server phải thay bằng link nội bộ

### 9. Create a Truststore (PKCS12 format) and import the root CA certificate
```
keytool -importcert -trustcacerts -file $CA_CERT -alias root-ca -keystore $TRUSTSTORE_FILE -storepass $PASSWORD -noprompt
```

- fix like mrs binh
```
keytool -importcert -trustcacerts -file authen-bookshop.crt -alias authen-bookshop -keystore truststore.p12 -storepass cybersoft123 -noprompt
```

- sau đó quất cái này ở authen ssl
```java
 protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String author = request.getHeader("Authorization");
        logger.info("Authorization: " + author);
        if(author != null && author.startsWith("Bearer ")){
            String token = author.substring(7);
            
            try{
                KeyStore trustStore = KeyStore.getInstance("PKCS12");
                try (InputStream is = new FileInputStream("truststore.p12")) {
                    trustStore.load(is, "cybersoft123".toCharArray());  // Pass của truststore
                }

                // Tạo TrustManager
                TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
                tmf.init(trustStore);

                // Tạo SSLContext
                SSLContext sslContext = SSLContext.getInstance("TLS");
                sslContext.init(null, tmf.getTrustManagers(), null);

                HttpClient client = HttpClient.newHttpClient();

                AuthenDecodeRequest decodeRequest = new AuthenDecodeRequest();
                decodeRequest.setToken(token);
                ObjectMapper objectMapper = new ObjectMapper();
                String requestBody = objectMapper.writeValueAsString(decodeRequest);
                logger.info("Request body: " + requestBody);
                HttpRequest rqAuthen = HttpRequest.newBuilder()
                        .uri(URI.create("https://localhost:8080/auth/decode"))
                        .header("Content-Type", "application/json")
                        .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                        .build();
                
                
                HttpResponse<String> respAuthen = client.send(rqAuthen, HttpResponse.BodyHandlers.ofString());
                logger.info("Response body:" + respAuthen.body());
                AuthenResponse authenResponse = objectMapper.readValue(respAuthen.body(),AuthenResponse.class);

                List<GrantedAuthority> listAuthor = new ArrayList<>();
                for (String role : authenResponse.getData()){
                    SimpleGrantedAuthority authority = new SimpleGrantedAuthority(role);
                    listAuthor.add(authority);
                }

                SecurityContext context = SecurityContextHolder.getContext();
                context.setAuthentication(new UsernamePasswordAuthenticationToken("","",listAuthor));
            } catch (Exception e) {
                throw new RuntimeException(e);
            }

        }

        filterChain.doFilter(request, response);
    }
```

## lại sinh key
- sai tên file common name:
### gateway trước

```ssh
openssl req -x509 -newkey rsa:2048 \
  -keyout gateway-bookshop.key \
  -out gateway-bookshop.crt \
  -days 365 \
  -nodes \
  -subj "/C=VN/ST=HCM/L=HCM/O=IVB/OU=IT/CN=localhost"
```

```
openssl pkcs12 -export   -in gateway-bookshop.crt   -inkey gateway-bookshop.key   -out keystore-gateway-bookshop.p12   -name gateway-bookshop -passout pass:cybersoft123
```

- authen
```
openssl req -x509 -newkey rsa:2048 \
  -keyout authen-bookshop.key \
  -out authen-bookshop.crt \
  -days 365 \
  -nodes \
  -subj "/C=VN/ST=HCM/L=HCM/O=IVB/OU=IT/CN=localhost"
```

```
openssl pkcs12 -export   -in authen-bookshop.crt   -inkey authen-bookshop.key   -out authen-bookshop.p12   -name authen -passout pass:cybersoft123
```

- bây giờ tới file certificate
```
keytool -importcert -trustcacerts -file authen-bookshop.crt -alias authen-bookshop -keystore truststore.p12 -storepass cybersoft123 -noprompt
```

- anh Bình học ai nè, mún tự build con ai
- 
- 

## biết thêm setup hệ thống
Tuỳ theo setup bao nhiêu lớp mạng thì mình đặt cho phù hợp
- HAproxy làm balancer --> bảo mật 3 tầng xong vô nginx --> gateway thuần --> service
- mình nhớ ghi vô cv là mình biết ssl, mình setup ssl cho web của mình rồi, và bít setup ở cả thằng java lun

## bảo hiểm xã hội:
3 tháng 
Time ngắn
học được gì
dự án này có gì để học, nó có giống dự án tương lai mình mún làm ko, tại nếu dự án này ngắn quá mình cần tìm dự án giống công ty tương lai mình để làm hơn

- bảo hiểm đóng kịch 40 tr
40%, 50%
Bhxh đóng đủ 15 năm nó là tiền hưu của mình nhen, mình hưởng 60-70 tiền hưu của mình

Bhtn: 1 năm đóng đủ bh được nhận bhtn, ví dụ mình làm bao lâu mình làm đủ 1 năm mình cộng đủ bhtn

Hình như giờ anh bình lãnh ko phải 11 tháng đâu mã mấy tháng gì đó
Note lại cái báo hôm
a
