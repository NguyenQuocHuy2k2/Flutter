# BÁO CÁO BÀI TẬP FLUTTER 1
## Xây dựng luồng chuyển trang (Navigation) cơ bản trong Flutter

**Môn học:** Lập trình Di động  
**Bài tập:** Bài tập Flutter 1  
**Nhóm thực hiện:**
- Nguyễn Quốc Huy – MSSV: 20110089 *(Nhóm trưởng)*
- Mai Công Phát – MSSV: 20146367 *(Thành viên)*

---

## I. MÔ TẢ YÊU CẦU BÀI TẬP

Xây dựng ứng dụng Flutter gồm 02 trang với luồng chuyển trang tự động:

| Trang | Tên | Chức năng |
|-------|-----|-----------|
| Trang 1 | Intro Screen | Giới thiệu thành viên nhóm, đếm ngược 10 giây rồi tự chuyển sang Trang 2 |
| Trang 2 | Login Screen | Giao diện đăng nhập dành cho vai trò Manager |

---

## II. CÁC BƯỚC THỰC HIỆN

### Bước 1: Khởi tạo Project Flutter

Mở Terminal, di chuyển đến thư mục muốn lưu project và tạo project mới:

```bash
cd ~/Documents/Project/Flutter
flutter create baitap_f01
cd baitap_f01
```

**Giải thích:**
- `flutter create baitap_f01`: Lệnh tạo project Flutter mới với tên `baitap_f01`.
- Flutter tự động sinh ra cấu trúc thư mục cơ bản bao gồm `lib/`, `android/`, `ios/`, `pubspec.yaml`, v.v.

Cấu trúc thư mục sau khi khởi tạo:
```
baitap_f01/
├── lib/
│   └── main.dart        ← File code chính (mặc định)
├── android/
├── ios/
├── pubspec.yaml         ← Khai báo dependencies
└── ...
```

---

### Bước 2: Lên kế hoạch cấu trúc code

Trước khi viết code, nhóm xác định cần tạo thêm thư mục `screens/` để chứa các trang riêng biệt, giúp code gọn gàng và dễ bảo trì:

```
lib/
├── main.dart                  ← Entry point của ứng dụng
└── screens/
    ├── intro_screen.dart      ← Trang 1: Giới thiệu thành viên
    └── login_screen.dart      ← Trang 2: Đăng nhập Manager
```

---

### Bước 3: Viết code Trang 1 – Intro Screen (`intro_screen.dart`)

Tạo file `lib/screens/intro_screen.dart` với các thành phần chính:

#### 3.1. Khai báo State và biến

```dart
class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  int _countdown = 10;          // Biến đếm ngược từ 10
  Timer? _timer;                // Timer để đếm ngược mỗi giây
  late AnimationController _fadeController;
  late AnimationController _progressController;
```

#### 3.2. Khởi tạo Timer đếm ngược trong `initState()`

```dart
@override
void initState() {
  super.initState();
  // Khởi chạy animation
  _fadeController.forward();
  _progressController.forward();
  // Bắt đầu đếm ngược
  _startCountdown();
}

void _startCountdown() {
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (!mounted) return;
    setState(() {
      _countdown--;
    });
    if (_countdown <= 0) {
      timer.cancel();
      _navigateToLogin();  // Tự động chuyển trang
    }
  });
}
```

**Giải thích kỹ thuật:**
- `Timer.periodic`: Tạo bộ đếm thời gian lặp lại mỗi 1 giây.
- `setState()`: Cập nhật lại giao diện mỗi khi `_countdown` thay đổi.
- Kiểm tra `_countdown <= 0` để dừng timer và gọi hàm điều hướng.

#### 3.3. Hàm chuyển trang bằng `Navigator.pushReplacement`

```dart
void _navigateToLogin() {
  if (!mounted) return;
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 500),
    ),
  );
}
```

**Giải thích kỹ thuật:**
- `Navigator.pushReplacement`: Chuyển trang và **xóa trang hiện tại** khỏi stack navigation. Người dùng **không thể nhấn Back** để quay lại Trang 1.
- `PageRouteBuilder` + `FadeTransition`: Tạo hiệu ứng chuyển trang mờ dần (fade).

#### 3.4. Giao diện (UI) Trang 1

- **Header:** Icon nhóm, tên nhóm, nhãn "Bài Tập Flutter 1".
- **Danh sách thành viên:** Dùng `ListView.builder` hiển thị các card thành viên với tên, vai trò, MSSV.
- **Khu vực đếm ngược:** Hiển thị số giây còn lại, thanh progress bar, nút "Bỏ qua".

---

### Bước 4: Viết code Trang 2 – Login Screen (`login_screen.dart`)

Tạo file `lib/screens/login_screen.dart` với:

#### 4.1. Form đăng nhập với validation

```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      // Trường Username
      TextFormField(
        controller: _usernameController,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Vui lòng nhập tên đăng nhập';
          }
          if (value.trim().length < 3) {
            return 'Tên đăng nhập tối thiểu 3 ký tự';
          }
          return null;
        },
      ),
      // Trường Password
      TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập mật khẩu';
          }
          if (value.length < 6) {
            return 'Mật khẩu tối thiểu 6 ký tự';
          }
          return null;
        },
      ),
    ],
  ),
)
```

#### 4.2. Xử lý sự kiện đăng nhập

```dart
void _handleLogin() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Giả lập API call
    setState(() => _isLoading = false);
    _showSuccessDialog();
  }
}
```

**Giải thích kỹ thuật:**
- `_formKey.currentState!.validate()`: Kiểm tra tất cả các trường trong Form.
- `Future.delayed`: Giả lập thời gian gọi API (2 giây).
- Hiển thị `CircularProgressIndicator` trong thời gian loading.

---

### Bước 5: Cập nhật `main.dart`

Sửa file `lib/main.dart` để ứng dụng khởi động từ `IntroScreen`:

```dart
import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài Tập Flutter 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const IntroScreen(),  // ← Trang đầu tiên khi mở app
    );
  }
}
```

---

### Bước 6: Kiểm tra và phân tích code

Chạy lệnh phân tích code để kiểm tra lỗi:

```bash
flutter analyze lib/
```

Kết quả: **No issues found** – code không có lỗi.

---

### Bước 7: Chạy thử ứng dụng

Kết nối thiết bị (máy ảo hoặc điện thoại thật) và chạy:

```bash
flutter run
```

**Luồng hoạt động khi chạy:**
1. App khởi động → hiển thị **Trang 1 (Intro Screen)**
2. Danh sách thành viên nhóm hiển thị, đồng thời bộ đếm ngược từ **10** bắt đầu chạy.
3. Progress bar màu vàng dần đầy theo thời gian.
4. Sau **10 giây**, app tự động chuyển sang **Trang 2 (Login Screen)** với hiệu ứng fade.
5. Người dùng nhập Username + Password → nhấn **ĐĂNG NHẬP**.
6. Sau 2 giây (giả lập loading) → hiển thị thông báo đăng nhập thành công.

> **Lưu ý:** Người dùng có thể nhấn nút **"Bỏ qua"** để chuyển ngay sang Trang 2 mà không cần đợi hết 10 giây. Sau khi chuyển, không thể nhấn Back để quay lại Trang 1 (do dùng `pushReplacement`).

---

### Bước 8: Đẩy code lên GitHub

Khởi tạo Git repository và đẩy lên GitHub:

```bash
# Khởi tạo git (nếu chưa có)
git init

# Thêm remote repository (thay YOUR_USERNAME và REPO_NAME)
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git

# Thêm tất cả file vào staging
git add .

# Commit với message theo yêu cầu
git commit -m "bài tập flutter 1"

# Đẩy code lên GitHub
git push -u origin main
```

---

## III. CẤU TRÚC PROJECT HOÀN CHỈNH

```
baitap_f01/
├── lib/
│   ├── main.dart                  ← Điểm khởi đầu, chọn IntroScreen làm home
│   └── screens/
│       ├── intro_screen.dart      ← Trang 1: Giới thiệu nhóm + đếm ngược
│       └── login_screen.dart      ← Trang 2: Đăng nhập Manager
├── android/                       ← Cấu hình Android
├── ios/                           ← Cấu hình iOS
├── pubspec.yaml                   ← Khai báo dependencies
└── ...
```

---

## IV. CÁC KỸ THUẬT FLUTTER ĐÃ SỬ DỤNG

| Kỹ thuật | Mô tả | Áp dụng tại |
|----------|-------|-------------|
| `StatefulWidget` | Widget có state thay đổi theo thời gian | `IntroScreen`, `LoginScreen` |
| `Timer.periodic` | Tạo bộ đếm thời gian lặp lại | `intro_screen.dart` – đếm ngược |
| `Navigator.pushReplacement` | Chuyển trang, xóa trang cũ khỏi stack | `intro_screen.dart` – chuyển sang Login |
| `PageRouteBuilder` | Tùy chỉnh hiệu ứng chuyển trang | `intro_screen.dart` – fade transition |
| `AnimationController` | Điều khiển animation | Fade-in, progress bar |
| `Form` + `TextFormField` | Form đăng nhập có validation | `login_screen.dart` |
| `Future.delayed` | Giả lập thời gian chờ bất đồng bộ | `login_screen.dart` – loading |
| `LinearProgressIndicator` | Thanh tiến trình | `intro_screen.dart` – đếm ngược |
| `ListView.builder` | Danh sách cuộn động | `intro_screen.dart` – danh sách thành viên |

---

*Báo cáo được tạo ngày 23/03/2026*
