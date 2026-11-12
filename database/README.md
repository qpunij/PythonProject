# 数据库说明（MySQL）

本系统数据库由 **SQLite 改成了 MySQL 8.0**，建表和初始数据都已经导出成 SQL 文件，
换台电脑只要导一次就能还原，不用重新录数据。

## 一、连接信息

| 项目 | 值 |
| --- | --- |
| 数据库版本 | MySQL 8.0.46 |
| 主机 / 端口 | 127.0.0.1 : 3306 |
| 库名 | `petcare` |
| 字符集 | `utf8mb4`（支持中文和 emoji） |
| 账号 | `petcare` |
| 密码 | `petcare123` |

账号 `petcare` 只对 `petcare` 这一个库有全部权限，不能碰别的库。
连接配置写在 `petcare/petcare/settings.py` 的 `DATABASES` 里。

> Django 默认用 `mysqlclient` 驱动，那玩意在 Windows 上要编译。
> 本项目改用纯 Python 的 `PyMySQL`，在 `petcare/petcare/__init__.py` 里
> 用 `pymysql.install_as_MySQLdb()` 顶替，效果一样，还不用装编译器。

## 二、三个 SQL 文件

| 文件 | 内容 | 什么时候用 |
| --- | --- | --- |
| `petcare_full.sql` | 建库 + 建表 + 全部数据（19 KB） | **推荐**，换电脑、交作业、答辩备份都用它 |
| `petcare_readable.sql` | 手写风格的精简版，3 张表 + 初始数据（6 KB） | **看代码、写报告用**，干净好读，也能单独导入 |
| `petcare_schema.sql` | 只有表结构，没有数据（11 KB） | 只要空表，数据自己重新录 |
| `petcare_data.sql` | 只有两张业务表的数据（3.5 KB） | 表结构已经有了，只想灌数据 |

> `petcare_full.sql` 和 `petcare_schema.sql` 是 `mysqldump` 直接导出的，
> 里面 `--` 开头的是注释（可以删），`/*!...*/` 开头的是 MySQL 的**条件执行指令**
> （控制字符集、时区、SQL 模式的），**不能删**，删了中文可能乱码。
> 看着乱就用 `petcare_readable.sql`。
>
> `petcare_readable.sql` 里的 `auth_user` 表是必须的 —— `pet` 表有外键指向它，
> 只建两张业务表会报表不存在。Django 其余的 10 张表由 `migrate` 创建。

## 三、怎么导入

**方式一：命令行**（在 `database` 目录下）

```bat
mysql -u root -p < petcare_full.sql
```

输入 root 密码后自动建库、建表、灌数据。

**方式二：图形工具**

Navicat / MySQL Workbench 里打开 `petcare_full.sql`，直接点执行。

> ⚠️ `petcare_full.sql` 开头有 `DROP DATABASE IF EXISTS petcare`，
> 会**先删掉同名的库再重建**。如果你库里已经有自己的数据，先备份！

## 四、换台电脑怎么恢复（完整流程）

```bat
:: 1. 导入数据库
mysql -u root -p < database\petcare_full.sql

:: 2. 建一个和 settings.py 里对应的账号（如果新机器上没有）
mysql -u root -p -e "CREATE USER IF NOT EXISTS 'petcare'@'localhost' IDENTIFIED BY 'petcare123'; GRANT ALL PRIVILEGES ON petcare.* TO 'petcare'@'localhost'; FLUSH PRIVILEGES;"

:: 3. 装依赖
pip install django==5.0 pymysql cryptography

:: 4. 启动
python manage.py runserver
```

> 不用再执行 `migrate`，表已经在 SQL 里了。硬要执行也不会坏，`migrate` 发现表已存在会跳过。

## 五、库里的表

业务表 2 张：

| 表名 | 说明 | 当前数据 |
| --- | --- | --- |
| `pet` | 宠物信息 | 3 条 |
| `sickness_record` | 就诊记录 | 5 条 |

Django 自带 11 张：`auth_user`、`auth_group`、`auth_permission`、
`auth_user_groups`、`auth_user_user_permissions`、`auth_group_permissions`、
`django_content_type`、`django_admin_log`、`django_migrations`、`django_session`。

### pet（宠物表）

```sql
CREATE TABLE `pet` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL COMMENT '宠物名',
  `species` varchar(10) NOT NULL COMMENT '种类',
  `gender` varchar(2) NOT NULL COMMENT '性别',
  `age` int unsigned NOT NULL COMMENT '年龄',
  `weight` decimal(5,2) NOT NULL COMMENT '体重',
  `created` datetime(6) NOT NULL COMMENT '录入时间',
  `owner_id` int NOT NULL COMMENT '主人，外键 → auth_user.id',
  PRIMARY KEY (`id`),
  CONSTRAINT `pet_owner_id_...` FOREIGN KEY (`owner_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### sickness_record（就诊记录表）

```sql
CREATE TABLE `sickness_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `disease` varchar(30) NOT NULL COMMENT '病名',
  `symptom` longtext NOT NULL COMMENT '症状',
  `visit_date` date NOT NULL COMMENT '就诊日期',
  `hospital` varchar(50) NOT NULL COMMENT '医院',
  `medicine` varchar(100) NOT NULL COMMENT '用药',
  `cost` decimal(8,2) NOT NULL COMMENT '花费',
  `status` varchar(10) NOT NULL COMMENT '治疗状态',
  `created` datetime(6) NOT NULL COMMENT '记录时间',
  `pet_id` bigint NOT NULL COMMENT '宠物，外键 → pet.id',
  PRIMARY KEY (`id`),
  CONSTRAINT `sickness_record_pet_id_...` FOREIGN KEY (`pet_id`) REFERENCES `pet` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

实际完整 DDL（含索引名、CHECK 约束）见 `petcare_schema.sql`。

## 六、常用命令

```bat
-- 进 MySQL 命令行
mysql -u petcare -ppetcare123 -h 127.0.0.1 -D petcare

-- 看表和数据
SHOW TABLES;
SELECT * FROM pet;
SELECT * FROM sickness_record;

-- 重新导出一份 SQL（改完数据后同步备份）
mysqldump -u petcare -ppetcare123 -h 127.0.0.1 --no-tablespaces --databases petcare > database\petcare_full.sql
```

## 七、从 SQLite 改过来的地方

| 位置 | 改动 |
| --- | --- |
| `settings.py` 的 `DATABASES` | `sqlite3` → `mysql`，填库名/账号/密码/端口，加 `charset: utf8mb4` |
| `petcare/__init__.py` | 新增 `pymysql.install_as_MySQLdb()` |
| 依赖 | 新增 `pymysql`、`cryptography`（MySQL 8 的密码认证要用到） |
| 字段类型 | SQLite 的 `varchar/integer` → MySQL 的 `varchar/int unsigned/bigint`，日期 → `date/datetime(6)` |
| 主键 | 变成 `bigint AUTO_INCREMENT` |

业务代码（models / views / forms / templates）**一行都没改** —— 这就是用 ORM 的好处，
换数据库只动配置。