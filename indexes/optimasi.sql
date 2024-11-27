USE rumah_sakit;

-- Indeks untuk kolom yang sering digunakan dalam JOIN dan WHERE
CREATE INDEX idx_pengguna_id_jenis_pengguna ON pengguna(id_jenis_pengguna);
CREATE INDEX idx_pasien_id_pengguna ON pasien(id_pengguna);
CREATE INDEX idx_pasien_id_asuransi ON pasien(id_asuransi);
CREATE INDEX idx_dokter_id_pengguna ON dokter(id_pengguna);
CREATE INDEX idx_dokter_id_spesialisasi ON dokter(id_spesialisasi);
CREATE INDEX idx_jadwal_dokter_id_dokter ON jadwal_dokter(id_dokter);
CREATE INDEX idx_staf_administrasi_id_pengguna ON staf_administrasi(id_pengguna);
CREATE INDEX idx_perawat_id_pengguna ON perawat(id_pengguna);
CREATE INDEX idx_kamar_id_tipe_kamar ON kamar(id_tipe_kamar);
CREATE INDEX idx_rawat_inap_id_pasien ON rawat_inap(id_pasien);
CREATE INDEX idx_rawat_inap_id_dokter ON rawat_inap(id_dokter);
CREATE INDEX idx_rawat_inap_id_kamar ON rawat_inap(id_kamar);
CREATE INDEX idx_rawat_jalan_id_pasien ON rawat_jalan(id_pasien);
CREATE INDEX idx_rawat_jalan_id_dokter ON rawat_jalan(id_dokter);
CREATE INDEX idx_rekam_medis_id_pasien ON rekam_medis(id_pasien);
CREATE INDEX idx_rekam_medis_id_dokter ON rekam_medis(id_dokter);
CREATE INDEX idx_rekam_medis_id_rawat_jalan ON rekam_medis(id_rawat_jalan);
CREATE INDEX idx_rekam_medis_id_rawat_inap ON rekam_medis(id_rawat_inap);
CREATE INDEX idx_rekam_medis_id_staf_administrasi ON rekam_medis(id_staf_administrasi);
CREATE INDEX idx_rekam_medis_perawat_id_rekam_medis ON rekam_medis_perawat(id_rekam_medis);
CREATE INDEX idx_rekam_medis_perawat_id_perawat ON rekam_medis_perawat(id_perawat);
CREATE INDEX idx_resep_id_rekam_medis ON resep(id_rekam_medis);
CREATE INDEX idx_resep_obat_id_resep ON resep_obat(id_resep);
CREATE INDEX idx_resep_obat_id_obat ON resep_obat(id_obat);
CREATE INDEX idx_pembayaran_id_pasien ON pembayaran(id_pasien);
CREATE INDEX idx_pembayaran_id_rekam_medis ON pembayaran(id_rekam_medis);