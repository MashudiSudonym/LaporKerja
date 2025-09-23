# LaporKerja

Aplikasi Android yang dirancang khusus untuk membantu freelancer yang bekerja mandiri dalam mengelola pekerjaan mereka secara efisien.

## Deskripsi

LaporKerja adalah aplikasi offline-first untuk freelancer yang memungkinkan pengelolaan proyek, pelacakan waktu, dan manajemen pendapatan. Aplikasi ini tetap berfungsi penuh tanpa koneksi internet, dengan sinkronisasi otomatis ke cloud saat tersedia.

## Fitur Utama

### Manajemen Proyek dan Tugas
- Membuat proyek baru dengan asosiasi klien
- Menambahkan tugas di bawah setiap proyek
- Status tugas: To-Do, In Progress, Completed, Revision
- Penetapan deadline untuk proyek dan tugas

### Pelacakan Waktu
- Timer aktif dengan fitur start/stop
- Entri waktu manual
- Laporan waktu per tugas, proyek, atau rentang waktu

### Manajemen Pendapatan
- Pencatatan pendapatan per proyek
- Status pembayaran: Belum Ditagih, Belum Lunas, Lunas, Lewat Jatuh Tempo
- Pencatatan uang muka atau pembayaran termin

### Fitur Tambahan
- Dashboard utama dengan ringkasan informasi
- Manajemen klien
- Laporan & analitik dengan grafik
- Pembuatan tagihan dalam format PDF
- Notifikasi & pengingat untuk deadline

## Tech Stack

- **Frontend**: Flutter (Dart) untuk cross-platform UI
- **Backend**: Supabase (PostgreSQL, autentikasi, realtime)
- **Database Lokal**: Drift (SQLite-based, type-safe)
- **State Management**: Riverpod dengan riverpod_generator
- **Data Models**: Freezed untuk immutable classes
- **Error Handling**: Result<T> untuk type-safe error handling di domain layer
- **Architecture**: Offline-first (local-first, background sync)

## Persyaratan Sistem

- Flutter SDK (versi fixed via Mise)
- Dart SDK
- Mise (untuk version management Flutter)
- Android Studio atau VS Code dengan ekstensi Flutter
- Perangkat Android untuk testing

## Setup dan Instalasi

1. **Clone repository**:
   ```bash
   git clone <repository-url>
   cd lapor_kerja
   ```

2. **Install Mise** (jika belum terinstall):
   ```bash
   curl https://mise.jdx.dev/install.sh | sh
   ```

3. **Setup Flutter version**:
   ```bash
   mise install
   ```

4. **Install dependencies**:
   ```bash
   flutter pub get
   ```

5. **Setup environment files**:
   - Buat folder `assets/dev` dan `assets/prod` jika belum ada:
     ```bash
     mkdir -p assets/dev assets/prod
     ```
   - Salin file `.env` ke `assets/dev/.env` untuk development
   - Salin file `.env` ke `assets/prod/.env` untuk production
   - Pastikan file `.env` berisi konfigurasi yang diperlukan (misalnya Supabase keys)

6. **Generate code**:
   ```bash
   flutter pub run build_runner build
   ```

7. **Run aplikasi**:
   - Development: `flutter run --flavor dev --target lib/main_dev.dart`
   - Production: `flutter run --flavor prod --target lib/main_prod.dart`

## Commands

- **Build**: `flutter build apk` (Android) atau `flutter build ios` (iOS)
- **Run**: `flutter run`
- **Test all**: `flutter test`
- **Test single**: `flutter test test/widget_test.dart` atau `flutter test --plain-name "Counter increments"`
- **Lint**: `flutter analyze`
- **Format**: `dart format .`
- **Code generation**: `flutter pub run build_runner build`
- **Database generation**: `flutter pub run build_runner build --delete-conflicting-outputs` (untuk Drift)

## Struktur Project

```
lapor_kerja/
├── android/
│   ├── app/
│   │   ├── src/
│   │   │   ├── debug/
│   │   │   ├── main/
│   │   │   │   ├── kotlin/
│   │   │   │   │   └── com/tigasatudesember/lapor_kerja/
│   │   │   │   ├── res/
│   │   │   │   │   ├── drawable/
│   │   │   │   │   ├── drawable-v21/
│   │   │   │   │   ├── mipmap-hdpi/
│   │   │   │   │   ├── mipmap-mdpi/
│   │   │   │   │   ├── mipmap-xhdpi/
│   │   │   │   │   ├── mipmap-xxhdpi/
│   │   │   │   │   ├── mipmap-xxxhdpi/
│   │   │   │   │   ├── values/
│   │   │   │   │   └── values-night/
│   │   │   │   └── AndroidManifest.xml
│   │   │   ├── profile/
│   │   │   └── AndroidManifest.xml
│   │   ├── build.gradle.kts
│   │   └── .gitignore
│   ├── gradle/
│   │   └── wrapper/
│   │       └── gradle-wrapper.properties
│   ├── .gitignore
│   ├── build.gradle.kts
│   ├── gradle.properties
│   └── settings.gradle.kts
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   └── utils/
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── main_page/
│   │   └── providers/
│   │       └── router/
│   ├── app.dart
│   ├── bootstrap.dart
│   ├── main_dev.dart
│   └── main_prod.dart
├── assets/
│   ├── dev/
│   └── prod/
├── test/
├── .vscode/
├── .idea/
│   ├── runConfigurations/
│   ├── caches/
│   └── libraries/
├── build/
├── .git/
│   └── refs/
├── .gitignore
├── .metadata
├── AGENTS.md
├── README.md
├── analysis_options.yaml
├── laporkerja-summary.md
├── mise.toml
├── pubspec.lock
└── pubspec.yaml
```

## Code Style

- **Imports**: Kelompokkan berdasarkan tipe (dart, flutter, third-party, local) dengan baris kosong di antara
- **Naming**: camelCase untuk variabel/fungsi, PascalCase untuk class, snake_case untuk file
- **Types**: Gunakan tipe eksplisit untuk public APIs, `const` untuk konstanta compile-time
- **Widgets**: Gunakan `const` constructors jika memungkinkan, prefer `StatelessWidget` over `StatefulWidget`
- **State management**: Gunakan Riverpod providers, hindari setState di widget kompleks
- **Error handling**: Gunakan `Result<T>` untuk operasi async di repositories, try-catch untuk operasi lain, throw custom exceptions
- **Annotations**: Gunakan `@freezed` untuk data classes, `@JsonSerializable` untuk JSON models, `@DriftTable` untuk database entities
- **Formatting**: Ikuti output dartfmt, indentasi 2-spasi, batas 80 karakter per baris
- **Documentation**: Gunakan `///` untuk public APIs, hindari komentar inline kecuali logika kompleks

## Contributing

1. Fork repository
2. Buat branch fitur baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## Lisensi

TBD