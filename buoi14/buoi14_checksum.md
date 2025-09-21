# Buoori 14

![alt text](image.png)
- checksum cho file gửi điđi
![alt text](image-1.png)
- back end nhận được cũng phải checksum cho file nhận được

- so sánh với file backend truyền lên
- checksum gửi đi so sanhs với checksum nhận được

- nó dùng md5, cái chuẩn mã hoá cùi nhất, vẫn bị tình trạng hacker nó có kiêns thức backend & front-end và cơ chế checksum thì nó vẫn tìm được.

```java
@Getter
@Setter
public class CreateProductRequest {
    private String title;
    private String author;
    private int review;
    private double price;
    private MultipartFile[] files;
    private String checkSum;
}
```


- giả sử có cái multipart file thì bây giờ checksum sao
- a: chuỗi checksum 1
- b: chuỗi checksum 2
- checksum lỡ file nào đi trước file nào đi sau thì sao, khi nào upload nhìu file thì người ta xài base64, vậy nên người ta chuyển về kiểu raw json

![alt text](image-2.png)
nên ngừoi ta để raw json như này
- rủi ro json bị, ko phải rủi ro, nhưng cái rủi ro json bị dài quá, ko đês nổi
- xài md5 bị mã hoá 2 chiều
- còn sha1 chỉ mã hoá 1 chiều


![alt text](image-3.png)
- neeus ko có checksum quét pentest nó sẽ báo bắt sửa lại hà
- [sha 125](https://l.facebook.com/l.php?u=https%3A%2F%2Femn178.github.io%2Fonline-tools%2Fsha256_checksum.html%3Ffbclid%3DIwZXh0bgNhZW0CMTEAAR6CGT5fJ98BzVW04SioMzQL7Guf5Yhob1thNFXnX_my0y1qyKayIIclmnQHLg_aem_xSuwh7DCT7__BIeJF6qnhw&h=AT3gBtwFRtaEL-mVBP0ebJYfOQuGHm_pC_MJSjuJs90SGq-kxdpFlJBlejnr6AoJgoEn-Urv5djd_mvtXd-lOoiFVEQlsWKS6L7TVIGHixNSyKDOlABGWRBYEGH2qWM&s=1)


- 