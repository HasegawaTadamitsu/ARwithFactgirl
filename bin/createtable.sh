
psql <<EOF

DROP TABLE   AA10000;
CREATE TABLE AA10000(
 serverid char(8),
 ymd char(8),
 seq1 integer,
 seq2 integer,
 name text ,
 primary key ( serverid,ymd,seq1,seq2 )
);

COMMENT ON TABLE  AA10000 IS 'お名前管理';
COMMENT ON COLUMN AA10000.serverid  IS 'サーバID';
COMMENT ON COLUMN AA10000.ymd      IS '有効年月日';
COMMENT ON COLUMN AA10000.seq1      IS 'シーケンス1';
COMMENT ON COLUMN AA10000.seq2      IS 'シーケンス2';
COMMENT ON COLUMN AA10000.name      IS 'お名前';


drop table   AA45000;
create table AA45000(
 ymd char(8),
 seq1 integer,
 seq2 integer,
 serveridx char(8),
 primary key ( ymd,seq1,seq2 )
);

COMMENT ON TABLE  AA45000 IS '索引';
COMMENT ON COLUMN AA45000.ymd      IS '有効年月日';
COMMENT ON COLUMN AA45000.seq1     IS 'シーケンス1';
COMMENT ON COLUMN AA45000.seq2     IS 'シーケンス2';
COMMENT ON COLUMN AA45000.serveridx     IS 'サーバID';

\q
EOF