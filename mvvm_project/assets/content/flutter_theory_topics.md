## Widget
icon: widgets
summary: Stateless/Stateful, build(), lifecycle
### Theory
- Widget là đơn vị nhỏ nhất để mô tả UI trong Flutter, toàn bộ màn hình là một cây widget lồng nhau từ lớn đến nhỏ.
- StatelessWidget phù hợp cho các phần hiển thị không có trạng thái nội tại thay đổi theo thời gian, ví dụ logo, tiêu đề cố định hoặc các component chỉ nhận dữ liệu từ bên ngoài.
- StatefulWidget bao gồm hai lớp: Widget và State, giúp tách cấu hình bất biến với trạng thái có thể thay đổi, từ đó Flutter chỉ rebuild đúng phần cần thiết.
- Vòng đời thường gặp gồm initState, didChangeDependencies, build, didUpdateWidget và dispose; hiểu đúng lifecycle giúp quản lý tài nguyên như Stream, AnimationController và TextEditingController an toàn.
- Trong kiến trúc lớn, widget nên giữ trách nhiệm hiển thị và điều hướng, còn nghiệp vụ nên đặt ở ViewModel/UseCase để giảm coupling và tăng khả năng test.
### Bullets
- StatelessWidget dùng khi UI không thay đổi theo tương tác nội bộ.
- StatefulWidget dùng khi cần cập nhật dữ liệu sau setState.
- build() có thể được gọi nhiều lần, cần viết hàm build thuần và nhẹ.
- dispose() phải giải phóng controller, listener, stream subscription.
===
## Layout
icon: grid_view
summary: Row/Column/Flex, Stack, GridView
### Theory
- Layout trong Flutter dựa trên cơ chế constraint: cha truyền giới hạn kích thước cho con, con tự chọn kích thước phù hợp rồi trả về cho cha.
- Row và Column rất mạnh nhưng dễ gây lỗi overflow nếu không dùng Expanded/Flexible trong các trường hợp nội dung dài hoặc màn hình nhỏ.
- Stack cho phép xếp chồng thành phần để tạo badge, floating panel, overlay hoặc background gradient tùy biến cao.
- ListView, GridView và CustomScrollView phục vụ dữ liệu lớn; cần ưu tiên builder constructor để render lazy và tiết kiệm bộ nhớ.
- Khi thiết kế responsive, nên kết hợp MediaQuery, LayoutBuilder và breakpoint để giao diện ổn định trên mobile/tablet/web.
### Bullets
- Hiểu constraint là chìa khóa để xử lý layout phức tạp.
- Expanded/Flexible giúp chia không gian theo tỷ lệ trong Row/Column.
- Stack + Positioned phù hợp cho UI xếp lớp.
- GridView.builder tốt cho danh sách sản phẩm dạng lưới.
===
## Navigation
icon: alt_route
summary: Navigator 1.0 / Named routes
### Theory
- Navigator quản lý stack của route; push thêm màn hình mới, pop để quay lại màn trước, tương tự cơ chế stack trong cấu trúc dữ liệu.
- Named routes giúp chuẩn hóa điều hướng ở app lớn, giảm hardcode MaterialPageRoute rải rác và dễ quản lý deep-link.
- Khi chuyển màn hình, có thể truyền argument đầu vào và nhận kết quả trả về (await Navigator.push) để xử lý tạo/sửa/xóa dữ liệu.
- Với ứng dụng doanh nghiệp, nên quy ước route theo module để tách rõ phạm vi feature và hỗ trợ test điều hướng tốt hơn.
- Router API (Navigator 2.0) phù hợp khi cần URL sync trên web hoặc flow điều hướng phức tạp nhiều nhánh.
### Bullets
- Navigator.push mở trang mới.
- Navigator.pop đóng trang và có thể trả dữ liệu ngược.
- Named route giảm coupling giữa các widget.
- Quy hoạch route rõ ràng giúp app dễ scale và bảo trì.
===
## State Management
icon: sync_alt
summary: setState, Provider (ChangeNotifier)
### Theory
- State là dữ liệu làm thay đổi UI; quản lý state hiệu quả giúp ứng dụng mượt, rõ luồng dữ liệu và dễ debug.
- setState phù hợp local state nhỏ trong một widget, nhưng không nên lạm dụng cho dữ liệu dùng chung nhiều màn hình.
- Provider + ChangeNotifier là lựa chọn đơn giản cho MVVM: ViewModel giữ nghiệp vụ và phát notifyListeners khi dữ liệu đổi.
- Nên tách state thành loading/data/error để UI phản ứng chính xác với các trạng thái bất đồng bộ.
- Quy tắc quan trọng: đặt state càng gần nơi sử dụng càng tốt, chỉ nâng scope lên khi thực sự có nhiều nơi cần dùng chung.
### Bullets
- Local state nhỏ: ưu tiên setState.
- Shared state nhiều widget: dùng Provider/ViewModel.
- Tách rõ loading, success, error để tránh logic rối.
- Không đặt nghiệp vụ nặng trực tiếp trong widget tree.
===
## Networking
icon: cloud_download
summary: HTTP, REST API, JSON
### Theory
- Networking thường gồm 4 bước: gọi API, parse dữ liệu, map DTO sang entity domain và cập nhật state trình bày.
- DTO giúp phản ánh đúng contract backend, còn entity domain giữ cấu trúc sạch cho nghiệp vụ nội bộ của app.
- Cần xử lý timeout, retry có kiểm soát, mã lỗi HTTP và thông điệp lỗi thân thiện cho người dùng.
- Với dữ liệu bất đồng bộ, FutureBuilder hoặc state management (Provider/BLoC) đều dùng được; app lớn nên gom logic vào repository/viewmodel.
- Bảo mật cơ bản gồm lưu token an toàn, refresh token hợp lý và hạn chế log dữ liệu nhạy cảm.
### Bullets
- Dùng package http để gọi REST API.
- Parse JSON thành DTO trước khi map sang entity.
- Xử lý timeout và lỗi mạng là bắt buộc.
- Tách API layer khỏi UI để dễ test và thay thế backend.
===
## Local Storage
icon: storage
summary: SQLite (sqflite), SharedPreferences
### Theory
- Local storage giúp app hoạt động ổn định khi mạng chậm hoặc offline, đồng thời giảm số lần gọi API không cần thiết.
- SharedPreferences phù hợp cấu hình nhỏ dạng key-value như theme, token ngắn hạn, cờ onboarding.
- SQLite (sqflite) phù hợp dữ liệu có quan hệ và truy vấn phức tạp như lịch sử giao dịch, giỏ hàng, danh mục.
- Nên xây repository thống nhất chiến lược cache: đọc local trước, sync nền với server và cập nhật lại viewmodel.
- Cần có versioning cho schema database để migration an toàn khi phát hành phiên bản mới.
### Bullets
- SharedPreferences: nhanh, đơn giản cho dữ liệu nhỏ.
- SQLite: mạnh cho dữ liệu có cấu trúc bảng.
- Cache local giúp giảm latency và tăng trải nghiệm.
- Luôn chuẩn bị migration khi thay đổi schema.
===
## UI/UX
icon: palette
summary: Theme, Material 3, responsive
### Theory
- UI tốt không chỉ đẹp mà còn nhất quán, dễ hiểu và giảm thao tác người dùng thông qua luồng rõ ràng.
- Theme tập trung màu sắc, typography, spacing để toàn app đồng bộ và giảm hardcode style ở từng widget.
- Material 3 cung cấp hệ token hiện đại (color roles, typography scale) giúp thiết kế linh hoạt cho nhiều bối cảnh.
- Responsive cần xét cả kích thước, mật độ thông tin và hành vi tương tác (touch vs mouse) khi chạy trên mobile/web/desktop.
- UX tốt cần trạng thái rõ ràng: loading, empty, error, success; mỗi trạng thái nên có thông điệp và hành động tiếp theo cụ thể.
### Bullets
- Xây design token giúp mở rộng giao diện có hệ thống.
- Dùng Material 3 để bám chuẩn thiết kế hiện đại.
- Thiết kế responsive theo breakpoint thay vì scale cứng.
- Luôn thiết kế đủ 4 state: loading/empty/error/success.
