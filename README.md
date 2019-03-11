# Grepp Project


<AWS 환경>
	ubuntu 16.04
	mysql 5.7
	tomcat8

<apt-get update>
	su
	apt-get update

<java 설치>
	apt-get install openjdk-8-jre
	apt-get install openjdk-8-jdk
	java -version
	javac -version
	which javac > 결과 /usr/bin/javac로 아래에서 사용
	readlink -f /usr/bin/javac
	
	vi /etc/profile
	최하단에 추가
	>	export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
		export PATH=$JAVA_HOME/bin:$PATH
		export CLASS_PATH=$JAVA_HOME/lib:$CLASS_PATH
	
	source /etc/profile
	
	echo $JAVA_HOME
	$JAVA_HOME/bin/javac -version
	환경변수 설정 확인
	
<tomcat8 설치>
	apt-get install tomcat8
	service tomcat8 start
	
<mysql 설치>
	설치 가능 버전 확인 / 설치
	sudo apt-cache search mysql-server
	sudo apt-get install mysql-server-5.7
	
	설정 수정
	vi /etc/mysql/conf.d/mysql.cnf
	>	 [mysqld]
		 datadir=/var/lib/mysql
		 socket=/var/lib/mysql/mysql.sock
		 user=mysql
		 character-set-server=utf8
		 collation-server=utf8_general_ci
		 init_connect = set collation_connection = utf8_general_ci
		 init_connect = set names utf8
		 
		 [mysql]
		 default-character-set=utf8
		 
		 [mysqld_safe]
		 log-error=/var/log/mysqld.log
		 pid-file=/var/run/mysqld/mysqld.pid
		 default-character-set=utf8
		 
		 [client]
		 default-character-set=utf8
		 
		 [mysqldump]
		 default-character-set=utf8
		
		입력
	
	재시작
	/etc/init.d/mysql restart
	
	외부 접속 허용
	mysql -uroot -p
	create database todo_list;
	create user 'xxung'@localhost identified by '0731';
	GRANT ALL PRIVILEGES ON todolist.* TO 'xxung'@localhost IDENTIFIED BY '0731';
	flush privileges;
	exit
	
	포트번호 허용
	ufw allow 3306/tcp
	
	vi /etc/mysql/mysql.conf.d/mysqld.cnf
	>	bind-address 주석처리
	
	재시작
	/etc/init.d/mysql restart

<프로젝트 업로드>
	폴더 권한 설정
	chmod -R 777 /var/lib/tomcat8/webapps
	chown -R tomcat8:tomcat8 /var/lib/tomcat8/webapps
	이클립스에서 git으로 연동한 후 프로젝트를 *.war로 export시켜
	우분투의 /var/lib/tomcat8/webapps/ 로 이동
	
	
<데이터베이스 생성>
	mysql -uroot -p
	
	todo_list database 생성
	CREATE DATABASE `todo_list`;
	
	list_contents table 생성
	CREATE TABLE `list_contents` (
		`list_key` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
		`list_title` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
		`list_content` TEXT NOT NULL COLLATE 'utf8_unicode_ci',
		`seq` INT(11) NOT NULL AUTO_INCREMENT,
		PRIMARY KEY (`list_key`),
		INDEX `seq` (`seq`)
	)
	COMMENT='contain TODO list title and contents'
	COLLATE='utf8_unicode_ci'
	ENGINE=InnoDB
	ROW_FORMAT=DYNAMIC
	AUTO_INCREMENT=0
	;
	
	list_priority table 생성
	CREATE TABLE `list_priority` (
		`list_key` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
		`list_pri` INT(11) NULL DEFAULT NULL,
		UNIQUE INDEX `list_key` (`list_key`),
		CONSTRAINT `FK_list_priority_list_contents` FOREIGN KEY (`list_key`) REFERENCES `list_contents` (`list_key`)
	)
	COMMENT='contain TODO list priority'
	COLLATE='utf8_unicode_ci'
	ENGINE=InnoDB
	ROW_FORMAT=DYNAMIC
	;
	
	list_status table 생성
	CREATE TABLE `list_status` (
		`list_key` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
		`list_date` DATE NULL DEFAULT NULL,
		`list_stat` VARCHAR(50) NULL DEFAULT NULL COMMENT '-1-알람완료 / 0-기간만료 / 1-우선순위 / 2-우선순위X / 3-완료 ' COLLATE 'utf8_unicode_ci',
		UNIQUE INDEX `list_key` (`list_key`),
		CONSTRAINT `FK_list_status_list_contents` FOREIGN KEY (`list_key`) REFERENCES `list_contents` (`list_key`)
	)
	COMMENT='contain TODO list deadline and status'
	COLLATE='utf8_unicode_ci'
	ENGINE=InnoDB
	ROW_FORMAT=DYNAMIC
	;
