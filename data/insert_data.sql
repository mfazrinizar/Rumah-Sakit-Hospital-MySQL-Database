USE rumah_sakit;

-- Isi Tabel

-- Isi data awal tabel jenis pengguna
INSERT INTO jenis_pengguna (id_jenis_pengguna, nama_jenis_pengguna)
VALUES
(UUID(), 'Dokter'),
(UUID(), 'Perawat'),
(UUID(), 'Staf Administrasi'),
(UUID(), 'Pasien');

-- Isi data awal tabel asuransi
INSERT INTO asuransi (id_asuransi, nama_asuransi, nomor_polis, coverage)
VALUES
(UUID(), 'Asuransi Sehat', 'POL123456', 10000000.00),
(UUID(), 'Asuransi Prima', 'POL654321', 20000000.00),
(UUID(), 'Asuransi Cerdas', 'POL987654', 15000000.00);

-- Isi Tabel Spesialisasi
INSERT INTO spesialisasi (id_spesialisasi, nama_spesialisasi)
VALUES
(UUID(), 'Penyakit Dalam'),
(UUID(), 'Anak'),
(UUID(), 'Bedah Umum'),
(UUID(), 'Gigi'),
(UUID(), 'Kandungan'),
(UUID(), 'Mata'),
(UUID(), 'THT');

-- Isi Tabel Tipe Kamar
INSERT INTO tipe_kamar (id_tipe_kamar, nama_tipe_kamar, deskripsi, harga_per_hari)
VALUES
(UUID(), 'VIP', 'Kamar dengan fasilitas premium', 1000000.00),
(UUID(), 'Kelas 1', 'Kamar dengan fasilitas standar tingkat 1', 750000.00),
(UUID(), 'Kelas 2', 'Kamar dengan fasilitas standar tingkat 2', 500000.00),
(UUID(), 'Kelas 3', 'Kamar dengan fasilitas dasar', 250000.00);

-- Isi Tabel Obat
INSERT INTO obat (id_obat, nama_obat, harga, stok)
VALUES
(UUID(), 'Paracetamol', 5000.00, 100),
(UUID(), 'Amoxicillin', 10000.00, 50),
(UUID(), 'Ranitidine', 7000.00, 75),
(UUID(), 'Cefadroxil', 15000.00, 30),
(UUID(), 'Asiklovir', 20000.00, 25),
(UUID(), 'Diazepam', 8000.00, 40),
(UUID(), 'Furosemide', 6000.00, 60),
(UUID(), 'Metformin', 9000.00, 45),
(UUID(), 'Ampisilin', 12000.00, 35),
(UUID(), 'Gentamisin', 61000.00, 50);

-- Isi Tabel Dokter
INSERT INTO pengguna (id_pengguna, id_jenis_pengguna, nama, email, password, alamat, nomor_telepon)
SELECT
    UUID(),
    (SELECT id_jenis_pengguna FROM jenis_pengguna WHERE nama_jenis_pengguna = 'Dokter'),
    CONCAT('dr. ', LPAD(n, 3, '0')),
    CONCAT(LPAD(n, 3, '0'), '@dokter.rumahsakit.com'),
    generate_salted_password('password123'),
    CONCAT('Alamat dokter ', LPAD(n, 3, '0')),
    CONCAT('0812', LPAD(FLOOR(RAND() * 10000000), 7, '0'))
FROM (
    WITH RECURSIVE seq AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM seq WHERE n < 200
    )
    SELECT n FROM seq
) AS temp_seq;

INSERT INTO dokter (id_dokter, id_pengguna, id_spesialisasi)
SELECT
    UUID(),
    (SELECT id_pengguna FROM pengguna WHERE email = CONCAT(LPAD(n, 3, '0'), '@dokter.rumahsakit.com')),
    s.id_spesialisasi
FROM (
    WITH RECURSIVE seq AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM seq WHERE n < 200
    )
    SELECT n FROM seq
) AS temp_seq
JOIN (
    SELECT ROW_NUMBER() OVER () AS rn, id_spesialisasi FROM spesialisasi
) s ON s.rn = ((n - 1) % (SELECT COUNT(*) FROM spesialisasi)) + 1;

-- Isi Tabel Pasien
-- Isi Tabel Pengguna untuk Pasien
INSERT INTO pengguna (id_pengguna, id_jenis_pengguna, nama, email, password, alamat, nomor_telepon)
SELECT
    UUID(),
    (SELECT id_jenis_pengguna FROM jenis_pengguna WHERE nama_jenis_pengguna = 'Pasien' LIMIT 1),
    CONCAT('Pasien ', LPAD(n, 3, '0')),
    CONCAT(LPAD(n, 3, '0'), '@pasien.rumahsakit.com'),
    generate_salted_password('password123'),
    CONCAT('Alamat pasien ', LPAD(n, 3, '0')),
    CONCAT('0814', LPAD(FLOOR(RAND() * 10000000), 7, '0'))
FROM (
    WITH RECURSIVE seq AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM seq WHERE n < 1500
    )
    SELECT n FROM seq
) AS temp_seq;

-- Isi Tabel Pasien
INSERT INTO pasien (id_pasien, id_pengguna, tanggal_lahir, jenis_kelamin, id_asuransi)
SELECT
    UUID(),
    (SELECT id_pengguna FROM pengguna WHERE email = CONCAT(LPAD(n, 3, '0'), '@pasien.rumahsakit.com') LIMIT 1),
    DATE_ADD('1990-01-01', INTERVAL n YEAR),
    IF(MOD(n, 2) = 0, 'L', 'P'),
    (SELECT id_asuransi FROM asuransi ORDER BY RAND() LIMIT 1)
FROM (
    WITH RECURSIVE seq AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM seq WHERE n < 1500
    )
    SELECT n FROM seq
) AS temp_seq;

-- Isi Tabel Kamar
INSERT IGNORE INTO kamar (id_kamar, nomor_kamar, id_tipe_kamar, lantai)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 1000
),
tipe_kam AS (
    SELECT id_tipe_kamar, ROW_NUMBER() OVER () AS rn
    FROM tipe_kamar
)
SELECT 
    UUID(),
    CONCAT(lantai, LPAD(n, 3, '0')),
    tk.id_tipe_kamar,
    lantai
FROM seq
CROSS JOIN (SELECT 1 AS lantai UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) AS fl
JOIN tipe_kam tk ON tk.rn = ((n - 1) % (SELECT COUNT(*) FROM tipe_kamar)) + 1
WHERE n <= 1000
ORDER BY lantai, n;


-- Isi Tabel Perawat
INSERT INTO pengguna (id_pengguna, id_jenis_pengguna, nama, email, password, alamat, nomor_telepon)
SELECT
    UUID(),
    (SELECT id_jenis_pengguna FROM jenis_pengguna WHERE nama_jenis_pengguna = 'Perawat'),
    CONCAT('Perawat ', LPAD(n, 3, '0')),
    CONCAT(LPAD(n, 3, '0'), '@perawat.rumahsakit.com'),
    generate_salted_password('password123'),
    CONCAT('Alamat perawat ', LPAD(n, 3, '0')),
    CONCAT('0813', LPAD(FLOOR(RAND() * 10000000), 7, '0'))
FROM (
    WITH RECURSIVE seq AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM seq WHERE n < 500
    )
    SELECT n FROM seq
) AS temp_seq;

INSERT INTO perawat (id_perawat, id_pengguna, shift)
SELECT
    UUID(),
    (SELECT id_pengguna FROM pengguna WHERE email = CONCAT(LPAD(n, 3, '0'), '@perawat.rumahsakit.com')),
    CASE MOD(n, 3)
        WHEN 1 THEN 'Pagi'
        WHEN 2 THEN 'Siang'
        ELSE 'Malam'
    END
FROM (
    WITH RECURSIVE seq AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM seq WHERE n < 500
    )
    SELECT n FROM seq
) AS temp_seq;

-- Isi Tabel Staf Administrasi
INSERT INTO pengguna (id_pengguna, id_jenis_pengguna, nama, email, password, alamat, nomor_telepon)
SELECT
    UUID(),
    (SELECT id_jenis_pengguna FROM jenis_pengguna WHERE nama_jenis_pengguna = 'Staf Administrasi'),
    CONCAT('Staf ', LPAD(n, 3, '0')),
    CONCAT(LPAD(n, 3, '0'), '@staf.rumahsakit.com'),
    generate_salted_password('password123'),
    CONCAT('Alamat staf ', LPAD(n, 3, '0')),
    CONCAT('0815', LPAD(FLOOR(RAND() * 10000000), 7, '0'))
FROM (
    WITH RECURSIVE seq AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM seq WHERE n < 100
    )
    SELECT n FROM seq
) AS temp_seq;

INSERT INTO staf_administrasi (id_staf_administrasi, id_pengguna)
SELECT
    UUID(),
    (SELECT id_pengguna FROM pengguna WHERE email = CONCAT(LPAD(n, 3, '0'), '@staf.rumahsakit.com'))
FROM (
    WITH RECURSIVE seq AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM seq WHERE n < 100
    )
    SELECT n FROM seq
) AS temp_seq;


-- Isi Tabel Rawat Jalan
INSERT INTO rawat_jalan (id_rawat_jalan, id_pasien, id_dokter, tanggal_kunjungan, diagnosis)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 500
)
SELECT
    UUID(),
    (SELECT id_pasien FROM pasien ORDER BY RAND() LIMIT 1),
    (SELECT id_dokter FROM dokter ORDER BY RAND() LIMIT 1),
    DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 365) DAY),
    CONCAT('Diagnosis ke-', n)
FROM seq;

-- Isi Tabel Rawat Inap
INSERT INTO rawat_inap (id_rawat_inap, id_pasien, id_dokter, id_kamar, tanggal_masuk, tanggal_keluar)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 1000
)
SELECT
    UUID(),
    (SELECT id_pasien FROM pasien ORDER BY RAND() LIMIT 1),
    (SELECT id_dokter FROM dokter ORDER BY RAND() LIMIT 1),
    (SELECT id_kamar FROM kamar ORDER BY RAND() LIMIT 1),
    DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 365) DAY),
    NULL
FROM seq;

-- Isi Tabel Rekam Medis
INSERT INTO rekam_medis (id_rekam_medis, id_pasien, id_dokter, id_rawat_jalan, id_rawat_inap, nomor_rekam_medis, jenis_rawat, id_staf_administrasi, diagnosis, tindakan, tanggal_pemeriksaan)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 1500
)
SELECT
    UUID(),
    (SELECT id_pasien FROM pasien ORDER BY RAND() LIMIT 1),
    (SELECT id_dokter FROM dokter ORDER BY RAND() LIMIT 1),
    CASE WHEN n % 2 = 1 THEN (SELECT id_rawat_jalan FROM rawat_jalan ORDER BY RAND() LIMIT 1) ELSE NULL END,
    CASE WHEN n % 2 = 0 THEN (SELECT id_rawat_inap FROM rawat_inap ORDER BY RAND() LIMIT 1) ELSE NULL END,
    LPAD(FLOOR(RAND() * 100000), 10, '0'),
    CASE WHEN n % 2 = 1 THEN 'Jalan' ELSE 'Inap' END,
    (SELECT id_staf_administrasi FROM staf_administrasi ORDER BY RAND() LIMIT 1),
    CONCAT('Diagnosis-', n),
    CONCAT('Tindakan-', n),
    DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 365) DAY)
FROM seq;

-- Isi Tabel Jadwal Dokter
INSERT INTO jadwal_dokter (id_jadwal, id_dokter, hari, jam_mulai, jam_selesai)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 1750
)
SELECT
    UUID(),
    (SELECT id_dokter FROM dokter ORDER BY RAND() LIMIT 1),
    CASE MOD(n, 7)
        WHEN 0 THEN 'Senin'
        WHEN 1 THEN 'Selasa'
        WHEN 2 THEN 'Rabu'
        WHEN 3 THEN 'Kamis'
        WHEN 4 THEN 'Jumat'
        WHEN 5 THEN 'Sabtu'
        ELSE 'Minggu'
    END,
    ADDTIME('08:00:00', SEC_TO_TIME(FLOOR(RAND() * 28800))), 
    '16:00:00'
FROM seq;

-- Isi Tabel Rekam Medis Perawat
INSERT INTO rekam_medis_perawat (id_rekam_medis, id_perawat)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 1500
),
rekam_medis_data AS (
    SELECT id_rekam_medis
    FROM rekam_medis
),
perawat_data AS (
    SELECT id_perawat
    FROM perawat
),
combinations AS (
    SELECT
        rm.id_rekam_medis,
        p.id_perawat,
        ROW_NUMBER() OVER (PARTITION BY rm.id_rekam_medis ORDER BY RAND()) AS perawat_order
    FROM rekam_medis_data rm
    CROSS JOIN perawat_data p
)
SELECT 
    c.id_rekam_medis, 
    c.id_perawat
FROM combinations c
WHERE c.perawat_order <= 2; 

-- Isi Tabel Resep
INSERT INTO resep (id_resep, id_rekam_medis)
SELECT 
    UUID(),
    id_rekam_medis
FROM (
    SELECT DISTINCT id_rekam_medis 
    FROM rekam_medis
    ORDER BY RAND()
    LIMIT 1500 
) rm;

-- Isi Tabel Resep Obat
INSERT INTO resep_obat (id_resep, id_obat, jumlah)
SELECT 
    r.id_resep,
    o.id_obat,
    FLOOR(RAND() * 5 + 1) 
FROM (
    SELECT DISTINCT id_resep 
    FROM resep 
    ORDER BY RAND()
    LIMIT 3000
) r
CROSS JOIN (
    SELECT DISTINCT id_obat
    FROM obat
    ORDER BY RAND()
    LIMIT 10
) o;

-- Isi Tabel Pembayaran
INSERT INTO pembayaran (id_pembayaran, id_pasien, id_rekam_medis, total_bayar, tanggal_pembayaran, metode_pembayaran)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 1000
)
SELECT 
    UUID(),
    (SELECT id_pasien FROM pasien ORDER BY RAND() LIMIT 1),        
    (SELECT id_rekam_medis FROM rekam_medis ORDER BY RAND() LIMIT 1), 
    ROUND(RAND() * 1000000 + 10000, 2),                              
    DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 365) DAY),       
    CASE MOD(n, 3)                                                   
        WHEN 0 THEN 'Tunai'
        WHEN 1 THEN 'Transfer'
        ELSE 'Asuransi'
    END
FROM seq;