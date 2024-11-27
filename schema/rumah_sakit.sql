--  Basis Data Kelompok 1 - Basis Data Rumah Sakit

CREATE DATABASE rumah_sakit;
USE rumah_sakit;

-- Tabel Asuransi
CREATE TABLE asuransi (
    id_asuransi CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    nama_asuransi VARCHAR(100) NOT NULL,
    nomor_polis VARCHAR(50) NOT NULL UNIQUE,
    coverage DECIMAL(10, 2) NOT NULL
);

-- Tabel Jenis Pengguna
CREATE TABLE jenis_pengguna (
    id_jenis_pengguna CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    nama_jenis_pengguna VARCHAR(50) NOT NULL UNIQUE
);

-- Tabel Pengguna
CREATE TABLE pengguna (
    id_pengguna CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    id_jenis_pengguna CHAR(36) NOT NULL,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    nomor_telepon VARCHAR(15) NOT NULL,
    FOREIGN KEY (id_jenis_pengguna) REFERENCES jenis_pengguna(id_jenis_pengguna)
);

-- Tabel Pasien
CREATE TABLE pasien (
    id_pasien CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    id_pengguna CHAR(36) NOT NULL,
    tanggal_lahir DATE NOT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    id_asuransi CHAR(36),
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna),
    FOREIGN KEY (id_asuransi) REFERENCES asuransi(id_asuransi)
);

-- Tabel Spesialisasi
CREATE TABLE spesialisasi (
    id_spesialisasi CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    nama_spesialisasi VARCHAR(100) NOT NULL UNIQUE
);

-- Tabel Dokter
CREATE TABLE dokter (
    id_dokter CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    id_pengguna CHAR(36) NOT NULL,
    id_spesialisasi CHAR(36),
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna),
    FOREIGN KEY (id_spesialisasi) REFERENCES spesialisasi(id_spesialisasi)
);

-- Tabel Jadwal Dokter
CREATE TABLE jadwal_dokter (
    id_jadwal CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    id_dokter CHAR(36) NOT NULL,
    hari ENUM('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu') NOT NULL,
    jam_mulai TIME NOT NULL,
    jam_selesai TIME NOT NULL,
    FOREIGN KEY (id_dokter) REFERENCES dokter(id_dokter)
);

-- Tabel Staf Administrasi
CREATE TABLE staf_administrasi (
    id_staf_administrasi CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    id_pengguna CHAR(36) NOT NULL,
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
);

-- Tabel Perawat
CREATE TABLE perawat (
    id_perawat CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    id_pengguna CHAR(36) NOT NULL,
    shift ENUM('Pagi', 'Siang', 'Malam') NOT NULL,
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
);

-- Tabel Tipe Kamar
CREATE TABLE tipe_kamar (
    id_tipe_kamar CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    nama_tipe_kamar VARCHAR(100) NOT NULL UNIQUE,
    deskripsi TEXT,
    harga_per_hari DECIMAL(10, 2) NOT NULL
);

-- Tabel Kamar 
CREATE TABLE kamar (
    id_kamar CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    nomor_kamar CHAR(4) NOT NULL UNIQUE,
    id_tipe_kamar CHAR(36) NOT NULL,
    lantai INT NOT NULL,
    FOREIGN KEY (id_tipe_kamar) REFERENCES tipe_kamar(id_tipe_kamar)
);

-- Tabel Rawat Inap
CREATE TABLE rawat_inap (
    id_rawat_inap CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    id_pasien CHAR(36) NOT NULL,
    id_dokter CHAR(36) NOT NULL,
    id_kamar CHAR(36) NOT NULL,
    tanggal_masuk DATE NOT NULL,
    tanggal_keluar DATE,
    FOREIGN KEY (id_pasien) REFERENCES pasien(id_pasien),
    FOREIGN KEY (id_dokter) REFERENCES dokter(id_dokter),
    FOREIGN KEY (id_kamar) REFERENCES kamar(id_kamar)
);

-- Tabel Rawat Jalan
CREATE TABLE rawat_jalan (
    id_rawat_jalan CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    id_pasien CHAR(36) NOT NULL,
    id_dokter CHAR(36) NOT NULL,
    tanggal_kunjungan DATE NOT NULL,
    diagnosis TEXT NOT NULL,
    FOREIGN KEY (id_pasien) REFERENCES pasien(id_pasien),
    FOREIGN KEY (id_dokter) REFERENCES dokter(id_dokter)
);

-- Tabel Rekam Medis
CREATE TABLE rekam_medis (
    id_rekam_medis CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    id_pasien CHAR(36) NOT NULL,
    id_dokter CHAR(36) NOT NULL,
    id_rawat_jalan CHAR(36),
    id_rawat_inap CHAR(36),
    nomor_rekam_medis CHAR(10) NOT NULL,
    jenis_rawat ENUM('Inap', 'Jalan') NOT NULL,
    id_staf_administrasi CHAR(36),
    diagnosis TEXT NOT NULL,
    tindakan TEXT,
    tanggal_pemeriksaan DATE NOT NULL,
    FOREIGN KEY (id_pasien) REFERENCES pasien(id_pasien),
    FOREIGN KEY (id_dokter) REFERENCES dokter(id_dokter),
    FOREIGN KEY (id_rawat_jalan) REFERENCES rawat_jalan(id_rawat_jalan),
    FOREIGN KEY (id_rawat_inap) REFERENCES rawat_inap(id_rawat_inap),
    FOREIGN KEY (id_staf_administrasi) REFERENCES staf_administrasi(id_staf_administrasi),
    CHECK (
        (jenis_rawat = 'Jalan' AND id_rawat_jalan IS NOT NULL AND id_rawat_inap IS NULL) OR
        (jenis_rawat = 'Inap' AND id_rawat_inap IS NOT NULL AND id_rawat_jalan IS NULL)
    )
);

-- Tabel Rekam Medis Perawat (Pivot Table)
CREATE TABLE rekam_medis_perawat (
    id_rekam_medis CHAR(36),
    id_perawat CHAR(36),
    PRIMARY KEY (id_rekam_medis, id_perawat),
    FOREIGN KEY (id_rekam_medis) REFERENCES rekam_medis(id_rekam_medis),
    FOREIGN KEY (id_perawat) REFERENCES perawat(id_perawat)
);

-- Tabel Obat
CREATE TABLE obat (
    id_obat CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    nama_obat VARCHAR(100) NOT NULL,
    harga DECIMAL(10, 2) NOT NULL,
    stok INT NOT NULL
);

-- Tabel Resep
CREATE TABLE resep (
    id_resep CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    id_rekam_medis CHAR(36) NOT NULL,
    FOREIGN KEY (id_rekam_medis) REFERENCES rekam_medis(id_rekam_medis)
);

-- Tabel Resep Obat (Pivot Table)
CREATE TABLE resep_obat (
    id_resep CHAR(36),
    id_obat CHAR(36),
    jumlah INT NOT NULL,
    PRIMARY KEY (id_resep, id_obat),
    FOREIGN KEY (id_resep) REFERENCES resep(id_resep),
    FOREIGN KEY (id_obat) REFERENCES obat(id_obat)
);

-- Tabel Pembayaran
CREATE TABLE pembayaran (
    id_pembayaran CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    id_pasien CHAR(36) NOT NULL,
    id_rekam_medis CHAR(36),
    total_bayar DECIMAL(15, 2) NOT NULL,
    tanggal_pembayaran DATE NOT NULL,
    metode_pembayaran ENUM('Tunai', 'Transfer', 'Asuransi') NOT NULL,
    FOREIGN KEY (id_pasien) REFERENCES pasien(id_pasien),
    FOREIGN KEY (id_rekam_medis) REFERENCES rekam_medis(id_rekam_medis)
);
