# buổi 4: upload nhìu file & lấy danh sách sản phẩm bằng search

- onion design pattern
  - , tất cả project của mịnhf xài 1 ngôn ngữ hoy
  - dành cho microservice dạng mono

- còn nếu mình xài mỗi cục source 1 ngôn ngữ khác thì mình xài strategies design pattern, là xài nhìu ngôn ngữ đó

- anh bình hướng dẫn lấy sản phẩm bằng search

![alt text](<Screenshot 2025-06-08 at 08.55.09.png>)

- Xong nó sẽ lên, quan tâm link bất hủ
- https://www.bezkoder.com/spring-boot-file-upload/

https://www.bezkoder.com/spring-boot-upload-multiple-files/

- đối với những dự án lớn mình sẽ có con central upload file riêng

```
file:
  path: ./uploads # đường dẫn lưu file upload, nhưng mình sẽ ko lưu vào source code mà mình lưu utrong ổ đĩa của mình lun
```
- mình phải kiểm tra folder có tồn tại ko, bằng cách biến folder này về dạng path để kiểm tra cho nó dễ

```java
@ControllerAdvice
public class CentralException {
    @ExceptionHandler()
    public ResponseEntity<BaseResponse> handleProductNotFound(Exception e) {
        BaseResponse response = new BaseResponse();
        response.setCode(HttpStatus.NOT_FOUND.value());
        response.setMessage(e.getMessage());

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
    }
}

```

- Xài getter setter an toàn hơn sẽ ko bị lệnh lặp vô tận, bấm @data dễ bị vòng lặp vô tận
- vì xài multipảt file nên mình dùng form data chứ ko dùng request body

```java
  @Override
    public ProductDTO createProduct(CreateProductRequest productRequest) {
        StringBuilder images = new StringBuilder();
        if(productRequest.getFiles()!= null && productRequest.getFiles().length > 0) {
           for(MultipartFile file: productRequest.getFiles()) {
               fileStorageServices.save(file);
               images.append(file.getOriginalFilename()).append(",");
           }
           images.deleteCharAt(images.length() - 1);
        }
        Product product = new Product();
        product.setTitle(productRequest.getTitle());
        product.setAuthor(productRequest.getAuthor());
        product.setReview(productRequest.getReview());
        product.setPrice(productRequest.getPrice());
        product.setImages(images.toString());

        product = productRepository.save(product);
        // Lưu ý: productRepository.save() sẽ trả về đối tượng Product đã được lưu vào CSDL, bao gồm cả ID tự động sinh ra.
        return ProductMapper.mapToDTO(product);
    }
```

- save file lỗi thì nó cũng ko sao


```json
{
    "code": 500,
    "message": "Identifier of entity 'com.cybersoft.bookshop_product.entity.Product' must be manually assigned before calling 'persist()'",
    "data": null
}
```
- tại vì uuid của nó ko tự động tạo nên minhf phải gán theome id cho nó

prepersisit
trước khi thực hiện lệnh thêm xoá sửa nó tự động chạy hàm .save liên quan tới persist thì nó sẽ chạy lệnh trong annotation prepersiit, thì nó sẽ chạy bên trong hàm trước xong nó restart lại xong nó gắn send 

- thêm cho anh 20 dữ liệu để làm cục search cho nó chuẩn, ko làm kiểu find all xong lọc tay bằng code nữa, mà dùng kiểu khác

- https://www.bezkoder.com/spring-boot-file-upload/ nó vẫn còn nhiều đoạn code chưa zô hết đâu

### search
- https://martian-station-399661.postman.co/workspace/Microservice~94a65592-6f6c-47d4-8542-b6d323d2041f/request/38306441-e2508dd7-99cb-4642-a40b-50d4d5089a1e?action=share&creator=38306441&ctx=documentation
- bình thường mình sẽ xài jpa, đầu tiên mình sẽ xài find all, mình sẽ xài 1 thằng mới của java 8 là filter, sẽ duyệt qua hết các mảng và kỉm tra các điều kiện, nếu thoả đk thì lấy data ra --> nhưng cách này ko tối ưu performance trên data
- vậy nên dùng thèn jpa hỗ trợ lun phân tráng và filter dưới database
- vậy nê nn làm thêm cục search product
- anh đang mún viết hàm search theo product của anh
- predicate là điều kiện where của mình, specification là 1 cách khác để viết câu query:
  - cách 1: jpa
  - cách 2 đặt tên hàm
  - cách 3 chính là specification này

![alt text](<Screenshot 2025-06-08 at 11.13.52.png>)

## bữa sau:
- học onion déisgn pattern, nó là dạng mono microservice
- bữa sau coi học onion được chưa
- học fe, trước khi học fe sẽ chỉ oinoen trueowcs
- 
- 
## BTVN: 
- làm cách nào đó tái sử dụng entity cho các project khác nhau