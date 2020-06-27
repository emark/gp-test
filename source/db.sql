CREATE TABLE message (created DATETIME(0) NOT NULL, id VARCHAR(500) NOT NULL, int_id CHAR(16) NOT NULL, str VARCHAR(1000) NOT NULL, status BOOL, CONSTRAINT message_id_pk PRIMARY KEY(id));
CREATE INDEX message_created_idx ON message (created);
CREATE INDEX message_int_id_idx ON message (int_id);
CREATE TABLE log (created DATETIME NOT NULL, int_id CHAR(16) NOT NULL, str VARCHAR(1000), address VARCHAR(100));
CREATE INDEX log_address_idx ON log (address);
