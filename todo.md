# Todo List Fitur LaporKerja - Prioritas untuk MVP

## Prioritas Tinggi (High) - Wajib untuk MVP

1. **Authentication (Login/Signup)**
   - **Deskripsi**: Implementasi login/signup dengan email/password menggunakan Supabase Auth, termasuk session management dan logout. Data user-specific (per freelancer).
   - **Alasan Prioritas**: Keamanan data personal (pendapatan, waktu kerja); mencegah akses tidak sah; Supabase sudah terintegrasi di bootstrap.
   - **Kompleksitas**: Medium (UI forms, auth state management dengan Riverpod).
   - **Estimasi**: 1 minggu.
   - **Status**: Pending

2. **Dashboard Utama**
   - **Deskripsi**: Halaman utama dengan ringkasan proyek aktif, total pendapatan bulan ini, tugas mendekati deadline, dan statistik cepat.
   - **Alasan Prioritas**: Entry point utama pengguna; meningkatkan engagement dan memberikan overview cepat tanpa navigasi manual.
   - **Kompleksitas**: Medium (query agregat dari database lokal, UI cards/grafik sederhana).
   - **Estimasi**: 1-2 minggu.
   - **Status**: Pending

3. **Timer Aktif untuk Time Tracking**
   - **Deskripsi**: Fitur start/stop timer real-time di task page, dengan auto-save ke time entries.
   - **Alasan Prioritas**: Core feature pelacakan waktu; saat ini hanya manual entry, timer membuatnya lebih user-friendly dan akurat.
   - **Kompleksitas**: Medium (state management timer, background persistence).
   - **Estimasi**: 1 minggu.
   - **Status**: Pending

4. **Auto-Sync Background**
   - **Deskripsi**: Sinkronisasi data lokal ke Supabase secara otomatis saat startup dan periodic, tanpa blokir UI.
   - **Alasan Prioritas**: Offline-first promise; saat ini sync manual, auto-sync memastikan data selalu up-to-date.
   - **Kompleksitas**: High (background tasks, conflict resolution).
   - **Estimasi**: 2 minggu.
   - **Status**: Pending

## Prioritas Medium (Medium) - Tingkatkan UX

5. **Notifikasi & Pengingat Deadline**
   - **Deskripsi**: Push notifications untuk tugas/proyek mendekati deadline, menggunakan permission yang sudah di-request.
   - **Alasan Prioritas**: Mencegah missed deadlines; fitur reminder standar untuk productivity app.
   - **Kompleksitas**: Medium (local notifications, scheduling).
   - **Estimasi**: 1 minggu.
   - **Status**: Pending

6. **Laporan & Analitik Dasar**
   - **Deskripsi**: Halaman laporan dengan grafik waktu kerja per proyek/bulan, pendapatan trends, dan export basic.
   - **Alasan Prioritas**: Value-add untuk freelancer; saat ini hanya list data, grafik memberikan insights.
   - **Kompleksitas**: Medium (chart library, query agregat).
   - **Estimasi**: 1-2 minggu.
   - **Status**: Pending

## Prioritas Rendah (Low) - Nice-to-Have

7. **Pembuatan Tagihan (Invoicing) PDF**
   - **Deskripsi**: Generate dan export invoice PDF dari data proyek/pendapatan.
   - **Alasan Prioritas**: Professional touch untuk billing; bisa ditunda jika MVP fokus pada tracking.
   - **Kompleksitas**: High (PDF generation library, template design).
   - **Estimasi**: 2-3 minggu.
   - **Status**: Pending

8. **Ekspor Data (CSV/Excel)**
   - **Deskripsi**: Export semua data ke CSV untuk backup/analisis eksternal.
   - **Alasan Prioritas**: Data portability; berguna tapi bukan core workflow.
   - **Kompleksitas**: Low (library existing).
   - **Estimasi**: 0.5 minggu.
   - **Status**: Pending

9. **Integrasi Kalender**
   - **Deskripsi**: Sync deadlines ke kalender device.
   - **Alasan Prioritas**: Convenience; opsional untuk MVP.
   - **Kompleksitas**: Medium (calendar API).
   - **Estimasi**: 1 minggu.
   - **Status**: Pending

## Clean Architecture Compliance Fixes

### Prioritas Tinggi (High) - Robustness & Consistency
10. **Expand Tests Coverage**
    - **Deskripsi**: Tambah unit tests untuk data sources (edge cases), widget tests untuk presentation layer, dan integration tests untuk full flows.
    - **Alasan Prioritas**: Robustness; memastikan semua layers testable sebelum rilis.
    - **Kompleksitas**: Medium (mocking, test setup).
    - **Estimasi**: 1 minggu.
    - **Status**: Completed

11. **Standardize Error Handling**
    - **Deskripsi**: Ganti try-catch di presentation dengan Result<T> untuk konsistensi; pastikan semua async ops menggunakan Result<T>.
    - **Alasan Prioritas**: Type-safe error handling; hindari exceptions di domain layer.
    - **Kompleksitas**: Low-Medium (refactor existing code).
    - **Estimasi**: 0.5 minggu.
    - **Status**: Completed

### Prioritas Medium (Medium) - Readability & Dependency
12. **Review Dependency Injection**
    - **Deskripsi**: Audit Riverpod providers untuk pure separation; hindari over-coupling dengan UI logic.
    - **Alasan Prioritas**: Dependency rule; maintainability.
    - **Kompleksitas**: Low (code review & refactor).
    - **Estimasi**: 0.5 minggu.
    - **Status**: Completed

13. **Add Development Order Documentation**
    - **Deskripsi**: Dokumentasikan urutan development (Domain → Data → Presentation) per fitur baru di todo.md atau AGENTS.md.
    - **Alasan Prioritas**: Consistency; panduan untuk fitur mendatang.
    - **Kompleksitas**: Low (add notes).
    - **Estimasi**: 0.2 minggu.
    - **Status**: Pending

## Rekomendasi Rilis
- **MVP Focus**: Prioritas High + Authentication untuk foundation aman.
- **Total Estimasi**: ~7-8 minggu untuk MVP yang aman dan fungsional.
- **Langkah Selanjutnya**: Mulai dengan Authentication, lalu Dashboard dan Timer.