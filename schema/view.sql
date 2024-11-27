USE rumah_sakit;

-- View Pasien Aktif Rawat Inap
CREATE VIEW view_pasien_aktif_rawat_inap AS
SELECT 
    pasien.id_pasien,
    pengguna.nama AS nama_pasien,
    kamar.nomor_kamar,
    kamar.lantai,
    tipe_kamar.nama_tipe_kamar,
    rawat_inap.tanggal_masuk,
    rawat_inap.tanggal_keluar
FROM rawat_inap
JOIN pasien ON rawat_inap.id_pasien = pasien.id_pasien
JOIN pengguna ON pasien.id_pengguna = pengguna.id_pengguna
JOIN kamar ON rawat_inap.id_kamar = kamar.id_kamar
JOIN tipe_kamar ON kamar.id_tipe_kamar = tipe_kamar.id_tipe_kamar
WHERE rawat_inap.tanggal_keluar IS NULL;

SELECT * FROM view_pasien_aktif_rawat_inap;

SELECT nama_pasien, nomor_kamar 
FROM view_pasien_aktif_rawat_inap
WHERE lantai = 2;

-- View Jadwal Dokter

CREATE VIEW view_jadwal_dokter AS
SELECT 
    dokter.id_dokter,
    pengguna.nama AS nama_dokter,
    spesialisasi.nama_spesialisasi,
    jadwal_dokter.hari,
    jadwal_dokter.jam_mulai,
    jadwal_dokter.jam_selesai
FROM jadwal_dokter
JOIN dokter ON jadwal_dokter.id_dokter = dokter.id_dokter
JOIN pengguna ON dokter.id_pengguna = pengguna.id_pengguna
JOIN spesialisasi ON dokter.id_spesialisasi = spesialisasi.id_spesialisasi;

SELECT * FROM view_jadwal_dokter;

SELECT nama_dokter, hari, jam_mulai, jam_selesai
FROM view_jadwal_dokter
WHERE nama_spesialisasi = 'Mata';

-- View Rekap Pembayaran Pasien

CREATE VIEW view_rekap_pembayaran_pasien AS
SELECT 
    pasien.id_pasien,
    pengguna.nama AS nama_pasien,
    SUM(pembayaran.total_bayar) AS total_pembayaran
FROM pembayaran
JOIN pasien ON pembayaran.id_pasien = pasien.id_pasien
JOIN pengguna ON pasien.id_pengguna = pengguna.id_pengguna
GROUP BY pasien.id_pasien, pengguna.nama;

SELECT * FROM view_rekap_pembayaran_pasien;

SELECT nama_pasien, total_pembayaran
FROM view_rekap_pembayaran_pasien
WHERE nama_pasien = 'Nama Pasien';


-- View Daftar Obat dengan Resep

CREATE VIEW view_daftar_obat_dengan_resep AS
SELECT 
    obat.id_obat,
    obat.nama_obat,
    SUM(resep_obat.jumlah) AS total_diresepkan,
    obat.stok
FROM resep_obat
JOIN obat ON resep_obat.id_obat = obat.id_obat
GROUP BY obat.id_obat, obat.nama_obat, obat.stok;

SELECT * FROM view_daftar_obat_dengan_resep;

SELECT nama_obat, stok 
FROM view_daftar_obat_dengan_resep
WHERE stok < 10;
