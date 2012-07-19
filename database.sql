create database elvenhut;
use elvenhut;
create table articles(id int(11) primary key AUTO_INCREMENT,author varchar(255),title varchar(255) not null,created_at datetime,updated_at datetime);
