# Ringkasan Konsep dan Tech Stack Aplikasi LaporKerja

## Konsep Aplikasi

**LaporKerja** adalah aplikasi Android yang dirancang khusus untuk membantu freelancer yang bekerja mandiri dalam mengelola pekerjaan mereka secara efisien.

### Kebutuhan Utama Freelancer
- Menambahkan task-task dari project yang didapat dari situs freelance
- Mencatat waktu dan tanggal kapan mulai dan selesai bekerja
- Mengatur deadline dari setiap pekerjaan
- Mencatat pendapatan dari tiap project
- Update status pembayaran

## Fitur Aplikasi

### Fitur Inti (Core Features)
1. **Manajemen Proyek dan Tugas (Project & Task Management)**
   - Membuat proyek baru dengan nama dan asosiasi klien
   - Menambahkan tugas di bawah setiap proyek
   - Status tugas: *To-Do*, *In Progress*, *Completed*, *Revision*
   - Penetapan deadline untuk proyek dan tugas individual

2. **Pelacakan Waktu (Time Tracking)**
   - Timer aktif dengan fitur *start/stop* untuk melacak waktu real-time
   - Entri waktu manual jika lupa menyalakan timer
   - Laporan waktu per tugas, per proyek, atau dalam rentang waktu tertentu

3. **Manajemen Pendapatan (Income Management)**
   - Pencatatan pendapatan untuk setiap proyek
   - Status pembayaran: *Belum Ditagih*, *Belum Lunas*, *Lunas*, *Lewat Jatuh Tempo*
   - Pencatatan uang muka atau pembayaran termin

### Fitur Tambahan (Suggested Features)
- **Dashboard Utama** dengan ringkasan informasi penting
- **Manajemen Klien** dengan database sederhana informasi klien
- **Laporan & Analitik** dengan grafik visual
- **Pembuatan Tagihan (Invoicing)** dalam format PDF
- **Notifikasi & Pengingat** untuk deadline dan tagihan

### Fitur Pengembangan Jangka Panjang
- Sinkronisasi Cloud
- Integrasi Kalender
- Ekspor Data (CSV/Excel)
- Dukungan Multi-Mata Uang

## Tech Stack Final

### Frontend
- **Flutter (Dart)**
  - Single codebase untuk Android & iOS
  - UI/UX yang kaya dan performa tinggi
  - Ekosistem pustaka yang matang

### Backend
- **Supabase**
  - Backend-as-a-Service (BaaS) gratis untuk memulai
  - Database PostgreSQL yang kuat
  - Autentikasi dan penyimpanan file terintegrasi
  - Fitur realtime untuk sinkronisasi

### Arsitektur
- **Offline-First Architecture**
  - Aplikasi tetap 100% fungsional tanpa internet
  - Pengalaman pengguna yang sangat cepat dan responsif
  - Hemat baterai dan kuota internet
  - Mengurangi beban pada API Supabase

### Database Lokal
- **Drift** (sebelumnya Moor)
  - Dibangun di atas SQLite yang teruji
  - Type-safe dengan Dart
  - Kompatibilitas sempurna dengan Riverpod, build_runner, dan Freezed
  - Tidak ada konflik dependensi yang diketahui

### State Management & Code Generation
- **Riverpod** dengan `riverpod_generator`
- **Freezed** untuk model data immutable
- **build_runner** sebagai alat code generation utama

### Error Handling
- **Result<T>** untuk type-safe error handling di domain layer repositories

## Analisis Tech Stack

| Komponen | Kelebihan | Pertimbangan | Peran |
|----------|-----------|--------------|--------|
| **Flutter** | - Single codebase untuk multi-platform<br>- UI/UX kaya & performa tinggi<br>- Ekosistem matang | - Ukuran app sedikit lebih besar<br>- Fitur platform spesifik perlu handling khusus | - Membangun seluruh UI aplikasi<br>- Logika sisi klien<br>- Interaksi dengan database lokal |
| **Supabase** | - Gratis untuk memulai<br>- Backend lengkap tanpa setup server<br>- PostgreSQL & fitur realtime | - Potensi vendor lock-in<br>- Keterbatasan free tier<br>- Butuh internet untuk sinkronisasi | - Penyimpanan data cloud<br>- Autentikasi pengguna<br>- Sinkronisasi antar perangkat |
| **Offline-First** | - Berfungsi tanpa internet<br>- UX sangat cepat<br>- Hemat baterai & kuota<br>- Mengurangi beban API | - Kompleksitas development tinggi<br>- Penanganan konflik data<br>- Butuh database lokal andal | - Fondasi cara kerja aplikasi<br>- Database lokal sebagai source of truth<br>- Logika sinkronisasi asinkron |

## Implementasi Database

### Struktur Tabel yang Direncanakan
1. **Projects** - Informasi dasar proyek
2. **Tasks** - Tugas-tugas spesifik dalam proyek
3. **TimeEntries** - Pencatatan sesi kerja
4. **Clients** - Database informasi klien
5. **Incomes** - Aspek finansial proyek

### Alur Kerja Offline-First
1. Pengguna melakukan aksi (tambah tugas, start timer, dll.)
2. Data langsung disimpan ke database lokal (Drift)
3. UI langsung diperbarui
4. Lapisan sinkronisasi bekerja di background
5. Data dikirim ke Supabase saat ada koneksi
6. Konflik data diselesaikan jika diperlukan

## Keunggulan Kompetitif

1. **Keandalan**: Aplikasi tetap berfungsi dalam kondisi jaringan tidak stabil
2. **Performa**: Respon UI yang sangat cepat karena data lokal
3. **Efisiensi**: Hemat baterai dan kuota internet pengguna
4. **Pengalaman**: UX yang superior dibandingkan aplikasi online-only

## Next Steps

1. Merancang skema database untuk Drift dan Supabase
2. Membuat Use Case Diagram untuk fitur-fitur utama
3. Merancang arsitektur aplikasi secara detail
4. Implementasi prototype fitur inti