## buổi 12

- singer sign on sẽ là tập trung 
- thư viện restant dev rất nhiều lỗi, a ko control đc

- tiếp theo cần làm gì để có thể phân quyền trên gateway, có thể gọi ra

- Trong gateway nó là forwareder, nó đã có sẵn controller, mình đặt cái custom filter vào xong mình gọi sẵn cục filter chứng, sử dụng lun security để phân quyền cho dễ, khỏi if else, security phải có context holder, nó là giấy thông hành, và nó chính là đoạn decode token, 

- bộ security là tập hợp của rất nhìu filter để chặn hết tất cả các link, bây giờ 
- giờ quy định khi giải mã thành công, code 200 thì nó là đăng nhập thành công, thì nó taọ ra chứng thực và đi tiếp cái ô 

- dùng lun thư viện spring security, nhớ là mỗi thằng 1 chức năng, gateway chỉ forwardẻr, nó sẽ rất hạn chế kết nối vz db, trừ khi bất đắc dĩ lắm thôi


- bữa học front-end anh sẽ chỉ cách deploy backend lunlun, nhớ nhắc anh
  - bữa đó a sẽ hướng dẫn nó lun, hướng dẫn trên server lun

- gọi decode giải mã token, chỗ này hỏi chatgpt
- Tôi đang xài spring boot, làm sao call được cho service khác để lấy dữ liệu, nhớ ko xaì Rest Template vì nó khó controller (nhưng cái này nghiệp dư, anh Bình phải đưa cho nó đúng thông tin, lấy đúng mô hình microserrvice càng nhìu càng tốt)

- tôi có 3 service như sau (anh Bình đang đưa nó ngữ cảnh): Gateway, Authen, Product cả 3 service đều sử dụng chung 1 eureka server, 
- Tôi đang sử dụng spring boot, vậy làm cách nào để gateway có thể gọi qua authen để lấy dữ liệu dùng httpClient, cái này siêu mạnh, ngoài ra còn cái HttpurlConnect cũng rất mạnh nữa

###  BTVN:
- làm lại redis, phải làm thực tế zô
- làm lại cái vụ call http client nhen