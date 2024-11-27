CREATE DATABASE rumah_sakit_universal;
USE rumah_sakit_universal;

-- Tabel Universal

CREATE TABLE universal (
    uuid CHAR(36) PRIMARY KEY DEFAULT (UUID()),

    -- Informasi Asuransi
    nama_asuransi VARCHAR(100),
    nomor_polis VARCHAR(50),
    coverage DECIMAL(10, 2),

    -- Informasi Pasien
    nama_pasien VARCHAR(100),
    alamat_pasien VARCHAR(255),
    tanggal_lahir_pasien DATE,
    nomor_telepon_pasien VARCHAR(15),
    jenis_kelamin_pasien ENUM('L', 'P'),

    -- Informasi Dokter
    nama_dokter VARCHAR(100),
    alamat_dokter VARCHAR(255),
    email_dokter VARCHAR(100),
    nomor_telepon_dokter VARCHAR(15),
    nama_spesialisasi_dokter VARCHAR(100),

    -- Jadwal Dokter
    hari_jadwal ENUM('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'),
    jam_mulai_jadwal TIME,
    jam_selesai_jadwal TIME,

    -- Informasi Staf Administrasi
    nama_staf_administrasi VARCHAR(100),
    alamat_staf_administrasi VARCHAR(255),
    email_staf_administrasi VARCHAR(100),
    nomor_telepon_staf_administrasi VARCHAR(15),

    -- Informasi Perawat
    nama_perawat VARCHAR(100),
    alamat_perawat VARCHAR(255),
    email_perawat VARCHAR(100),
    nomor_telepon_perawat VARCHAR(15),
    shift ENUM('Pagi', 'Siang', 'Malam'),

    -- Informasi Tipe Kamar
    nama_tipe_kamar VARCHAR(100),
    deskripsi_tipe_kamar TEXT,
    harga_per_hari DECIMAL(10, 2),

    -- Informasi Kamar
    nomor_kamar CHAR(4),
    lantai INT,

    -- Informasi Rawat Inap
    tanggal_masuk_rawat_inap DATE,
    tanggal_keluar_rawat_inap DATE,

    -- Informasi Rawat Jalan
    tanggal_kunjungan_rawat_jalan DATE,
    diagnosis_rawat_jalan TEXT,

    -- Rekam Medis
    nomor_rekam_medis CHAR(10),
    jenis_rawat ENUM('Inap', 'Jalan'),
    diagnosis_rekam_medis TEXT,
    tindakan_rekam_medis TEXT,
    tanggal_pemeriksaan DATE,

    -- Obat
    nama_obat VARCHAR(100),
    harga_obat DECIMAL(10, 2),

    -- Resep, Banyaknya Obat
    jumlah_resep INT,

    -- Pembayaran
    total_bayar DECIMAL(15, 2),
    tanggal_pembayaran DATE,
    metode_pembayaran ENUM('Tunai', 'Transfer', 'Asuransi')
);