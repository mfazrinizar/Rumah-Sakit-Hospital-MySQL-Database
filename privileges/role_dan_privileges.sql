USE rumah_sakit;

-- Pembuatan Role Admin
CREATE ROLE 'admin';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%';
GRANT 'admin' TO 'admin_user'@'%';

-- Pembuatan Role Dokter
CREATE ROLE 'dokter';
GRANT SELECT, UPDATE ON rawat_jalan TO 'dokter'@'%';
GRANT SELECT, UPDATE ON rawat_inap TO 'dokter'@'%';
GRANT SELECT, UPDATE ON rekam_medis TO 'dokter'@'%';
GRANT SELECT, INSERT, UPDATE ON jadwal_dokter TO 'dokter'@'%';
GRANT SELECT ON pasien TO 'dokter'@'%';
GRANT 'dokter' TO 'dokter_user'@'%';

-- Pembuatan Role Perawat
CREATE ROLE 'perawat';
GRANT SELECT ON rekam_medis TO 'perawat'@'%';
GRANT SELECT ON rekam_medis_perawat TO 'perawat'@'%';
GRANT SELECT ON pasien TO 'perawat'@'%';
GRANT 'perawat' TO 'perawat_user'@'%';

-- Pembuatan Role Staf Administrasi
CREATE ROLE 'staf_administrasi';
GRANT SELECT, INSERT, UPDATE ON rekam_medis TO 'staf_administrasi'@'%';
GRANT SELECT, INSERT, UPDATE ON staf_administrasi TO 'staf_administrasi'@'%';
GRANT SELECT, INSERT, UPDATE ON rawat_jalan TO 'staf_administrasi'@'%';
GRANT SELECT, INSERT, UPDATE ON rawat_inap TO 'staf_administrasi'@'%';
GRANT SELECT ON pasien TO 'staf_administrasi'@'%';
GRANT SELECT, INSERT, UPDATE ON pembayaran TO 'staf_administrasi'@'%';
GRANT SELECT ON kamar TO 'staf_administrasi'@'%';
GRANT SELECT ON jadwal_dokter TO 'staf_administrasi'@'%';
GRANT 'staf_administrasi' TO 'staf_administrasi_user'@'%';

-- Pembuatan Role Pasien
CREATE ROLE 'pasien';
GRANT SELECT ON rawat_jalan TO 'pasien'@'%';
GRANT SELECT ON rawat_inap TO 'pasien'@'%';
GRANT SELECT ON rekam_medis TO 'pasien'@'%';
GRANT SELECT ON pembayaran TO 'pasien'@'%';
GRANT 'pasien' TO 'pasien_user'@'%';
