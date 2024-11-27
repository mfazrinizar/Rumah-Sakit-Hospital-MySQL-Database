USE rumah_sakit;

-- 1. Menampilkan Pasien Rawat Inap yang Masih Dirawat 
SELECT 
    pasien.id_pasien, 
    pengguna.nama AS nama_pasien, 
    dokter_pengguna.nama AS nama_dokter, 
    kamar.nomor_kamar, 
    rawat_inap.tanggal_masuk 
FROM 
    rawat_inap 
JOIN pasien ON rawat_inap.id_pasien = pasien.id_pasien 
JOIN pengguna ON pasien.id_pengguna = pengguna.id_pengguna 
JOIN dokter ON rawat_inap.id_dokter = dokter.id_dokter 
JOIN pengguna AS dokter_pengguna ON dokter.id_pengguna = dokter_pengguna.id_pengguna 
JOIN kamar ON rawat_inap.id_kamar = kamar.id_kamar 
WHERE 
    rawat_inap.tanggal_keluar IS NULL;


-- 2. Menampilkan Dokter yang Tidak Memiliki Jadwal Praktek
SELECT 
    dokter.id_dokter, 
    pengguna.nama AS nama_dokter, 
    spesialisasi.nama_spesialisasi 
FROM 
    dokter 
JOIN pengguna ON dokter.id_pengguna = pengguna.id_pengguna 
LEFT JOIN jadwal_dokter ON dokter.id_dokter = jadwal_dokter.id_dokter 
LEFT JOIN spesialisasi ON dokter.id_spesialisasi = spesialisasi.id_spesialisasi 
WHERE 
    jadwal_dokter.id_jadwal IS NULL;

-- 3. Menampilkan Rekam Medis Pasien Berdasarkan Spesialisasi Dokter
SELECT 
    rekam_medis.id_rekam_medis, 
    pengguna_pasien.nama AS nama_pasien, 
    pengguna_dokter.nama AS nama_dokter, 
    spesialisasi.nama_spesialisasi 
FROM 
    rekam_medis 
JOIN pasien ON rekam_medis.id_pasien = pasien.id_pasien 
JOIN pengguna AS pengguna_pasien ON pasien.id_pengguna = pengguna_pasien.id_pengguna 
JOIN dokter ON rekam_medis.id_dokter = dokter.id_dokter 
JOIN pengguna AS pengguna_dokter ON dokter.id_pengguna = pengguna_dokter.id_pengguna 
JOIN spesialisasi ON dokter.id_spesialisasi = spesialisasi.id_spesialisasi;


-- 4. Menampilkan Obat yang Paling Sering Diresepkan
SELECT 
    obat.id_obat, 
    obat.nama_obat, 
    COUNT(resep_obat.id_resep) AS jumlah_diresepkan 
FROM 
    resep_obat 
JOIN obat ON resep_obat.id_obat = obat.id_obat 
GROUP BY 
    obat.id_obat, obat.nama_obat 
ORDER BY 
    jumlah_diresepkan DESC 
LIMIT 1;

-- 5. Menampilkan Total Pendapatan Rumah Sakit Berdasarkan Metode Pembayaran

SELECT 
    metode_pembayaran, 
    SUM(total_bayar) AS total_pendapatan 
FROM 
    pembayaran 
GROUP BY 
    metode_pembayaran;
