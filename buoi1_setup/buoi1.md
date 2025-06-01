# buổi 1
- chọn dự án: Bookshop
  - quản lý bãi đỗ xe
  - quản lý lịch hẹn bác sĩ

### các techstack mà senior bắt buộc biết khi làm

OAuth2: mặc định hoặc tự xây
- Git: Hoàn chỉnh (70%) thực tế như bên ngoài làm
- Kafka
- Redis
- Log
- Swagger: open API generator
- CI/CD github/gitlab optional (ko biết có free hay ko)
- ELK: 
  - elactis search
  - Kibana:
  - firebeat
  - Logtash
  - Queue (optional) : dạy theo hướng queue nhưng những hướng khác a sẽ hướng dẫn mình lun
- Gateway: tự xây theo kiểu buổi trước mình học

Dự án 2:
- OAuth2: sử dụng thư viện Keycloak
  - Prometheus
  - Grafana

- Gateway: 
  - NginX
  - KongGateway

- auto fill: xuất file pdf, điền nội dung vào file pdf

- system OTT: là gửi mail, sms, push noti, nó đang cần cục source riêng của mình
- system transaction: 
  - bản chất system là cái project mà tại sao hông gọi là project mà gọi là system này system kia
  - lý do dùng chữ system đơn giản thui vì sau này nó sẽ được dùng để triển khai trên hệ thống khác nữa, chứ ko dùng chỉ 1 chỗ này

![alt text](image.png)

![alt text](image-1.png)

### Trước khi vẽ usecase thì cần xác định rõ trước?
- B1: đối tượng sử dụng là ai? actor là ai?
- B2: các tính năng trong dự án sẽ thực hiện?
- B3: đối tượng nào sử dụng các tính năng nào?

### btvn
có btvn để làm luôn, giống thực tế bên ngoài làm, những công nghệ mình làm mình tự quyết định. Trước nội dung ngày hôm sau thì sẽ làm luôn bài tập, xong sửa xong giao kiến thức mới.
- trong các buổi microservice, đưa iu cầu bt mới, kiến thức mới --> xong làm kiến thức mới


### Bước 1: đối tượng nào sử dụng các tính năng nào?
- tức là actor nào, thì có 2 actor: user với admin

### Bước 2: các tính năng trong dự án sẽ thực hiện?
- đăng nhập (nếu ko dành cho user thì cũng dành cho admin)

![alt text](image-2.png)
![alt text](image-3.png)

- bước 2b: thằng nào dùng tính năng nào ghi ra

- xem danh sách sản phẩm
![alt text](image-4.png)

- Xem danh sách sản phấm
- Xem sản phẩm theo danh mục

### tiêu chí đánh giá và tách microservice

Bước 2: tiêu chí đánh giá và tách microservice

chính là CCU: concurrence user số lượng người truy cập đồng thời --> tính được sizing, tức là cấu hình tối thiểu để chạy được dự án của mình. Mà khác cái game, game offline thì ko cần iu cầu, nhưng 

- căn cứ vào ccu: để đáp ứng được cấu hình 1k user thì cần cấu hình ntn, 1tr user thì cấu hình ntn

- tính năng đó có được sử dụng **nhiều** và **liên tục** bởi user hay ko
- tính năng đó có **quan trọng** với nghiệp vụ của dự án mình hay ko

### Bước 3: tối ưu performance (liên quan tới sử dụng cache)
- 3 tiu chí này mình cần hình dung từ đầu để hình dung ra dự án, trong đầu ngay
  - Data có truy vấn liên tục ko
  - người dùng có sử dụng nhiều ko
  - data có thay đổi thường xuyên ko
- ưu và nhược điểm dùng ram để lưu cache, ưu và nhược khi dùng redis để lưu cache
- tại sao xài redis thay cho thằng mem cache (data lưu thẳng trực tiếp trên thanh ram). 2 là sử dụng các hệ thống lưu trữ để cache, khi nào nó lưu data đơn giản thì mới xài, thứ hai là data nên lưu trên local, trên máy tính, lưu thành file để khi có sập thì nó còn, để khi mở lại máy vẫn còn


#### dựa vào các tiêu chí a nói trên, thì cái nào nên dùng để tách microservice?
- giỏ hàng anh sẽ ko tách microservice vì sao?
  - người ta sẽ ko truy cập vào liên tục và tương tác liên tục trong giỏ hàng, nhiều khi người ta lướt ơi là lướt xong người ta cũng hông xài
  - vì ko xài **nhiều** và **liên tục** bởi user

## btvn
- làm cục source authentication đầu tiên trước, làm trước tính năng đăng nhập ko cần đăng kí (đăng  nhập là tính năng bắt buộc), có sử dụng jwt
 