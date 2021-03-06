-- Function: public._init_skycamt_schema()

-- DROP FUNCTION public._init_skycamt_schema();

CREATE OR REPLACE FUNCTION public._init_skycamt_schema()
  RETURNS void AS
$BODY$
BEGIN

-- DROP SCHEMA skycamt CASCADE;

-- SCHEMA
CREATE SCHEMA skycamt;

-- TABLES
CREATE TABLE skycamt.images(
	img_id uuid primary key,
	img_date timestamp NOT NULL,
	img_rundate timestamp NOT NULL,
	mjd real NOT NULL,
	utstart time NOT NULL,
	ra_cent real NOT NULL,
	dec_cent real NOT NULL,
	ra_min real NOT NULL,
	ra_max real NOT NULL,
	dec_min real NOT NULL,
	dec_max real NOT NULL,
	ccdstemp real NOT NULL,
	ccdatemp real NOT NULL,
	azdmd real NOT NULL,
	azimuth real NOT NULL,
	altdmd real NOT NULL,
	altitude real NOT NULL,
	rotskypa real NOT NULL,
	filename char(35) NOT NULL,
	frame_zp_APASS real,
	frame_zp_stdev_APASS real,
        frame_zp_m_APASS real,
        frame_zp_c_APASS real,
	frame_zp_USNOB real,
	frame_zp_stdev_USNOB real,
        frame_zp_m_USNOB real,
        frame_zp_c_USNOB real,
	has_processed_successfully boolean default false
);

CREATE TABLE skycamt.catalogue(
	skycamref uuid primary key,
	xmatch_apassref bigint NULL,
	xmatch_apass_distasec real NULL,
	xmatch_usnobref char(12) NULL,
	xmatch_usnob_distasec real NULL,
	firstobs_date timestamp NULL,
	lastobs_date timestamp NULL,
	radeg real NOT NULL,
	decdeg real NOT NULL,
	raerrasec real NOT NULL,
	decerrasec real NOT NULL,
	nobs bigint NOT NULL,
	xmatch_apass_brcolour real,
	xmatch_usnob_brcolour real,
	xmatch_apass_rollingmeanmag real,
	xmatch_apass_rollingstdevmag real,
	xmatch_usnob_rollingmeanmag real,
	xmatch_usnob_rollingstdevmag real,
	xmatch_apass_ntimesswitched int,
	xmatch_usnob_ntimesswitched int,
	pos spoint NOT NULL
);

CREATE TABLE skycamt.sources(
	src_id bigserial unique primary key,
	img_id uuid NOT NULL references skycamt.images(img_id),
	skycamref uuid NULL references skycamt.catalogue(skycamref),
	mjd real NOT NULL,
	radeg real NOT NULL,
	decdeg real NOT NULL,
	x_pix real NOT NULL,
	y_pix real NOT NULL,
	flux real NOT NULL,
	flux_err real NOT NULL,
	inst_mag real NOT NULL,
	inst_mag_err real NOT NULL,
	background real NOT NULL,
	isoarea_world real NOT NULL,
	seflags smallint NOT NULL,
	fwhm real NOT NULL,
	elongation real NOT NULL,
	ellipticity real NOT NULL,
	theta_image real NOT NULL,
	pos spoint NOT NULL
);	

-- INDEXES
CREATE INDEX idx_images_mjd ON skycamt.images(mjd);

CREATE INDEX idx_xmatch_catalogue_usnobref ON skycamt.catalogue(xmatch_usnobref);
CREATE INDEX idx_xmatch_catalogue_pos ON skycamt.catalogue USING GIST(pos);
CREATE INDEX idx_xmatch_catalogue_apassref ON skycamt.catalogue(xmatch_apassref);

CREATE INDEX idx_sources_mjd ON skycamt.sources(mjd);
CREATE INDEX idx_sources_skycamref ON skycamt.sources(skycamref)
CREATE INDEX idx_sources_inst_mag ON skycamt.sources(inst_mag);
CREATE INDEX idx_sources_pos ON skycamt.sources USING GIST(pos);

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public._init_skycamt_schema()
  OWNER TO eng;

