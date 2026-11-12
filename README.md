# 宠物生病管理系统（Django + MySQL）

《PythonWeb程序设计》课程设计 —— 基于 Django 的宠物生病管理系统。

## 一、怎么跑起来

### 1. 确认 MySQL 服务在运行

`Win + R` 输入 `services.msc`，找到 **MySQL80**，状态要是"正在运行"。

### 2. 导入数据库（第一次或换电脑时做一次）

```bat
cd petcare
mysql -u root -p < database\petcare_full.sql
```

输入 MySQL 的 root 密码，会自动建库 `petcare`、建表、灌好演示数据。
库建好了就不用再执行 `migrate`（硬要执行也没事，表已存在会跳过）。

### 3. 启动

```bat
cd petcare
..\myenv\Scripts\python.exe manage.py runserver
```

浏览器打开 <http://127.0.0.1:8000/>。

用 PyCharm 的话，解释器选 `petcare\.venv\Scripts\python.exe`（Django 和 PyMySQL 都装好了），
然后在 Terminal 里敲 `python manage.py runserver`。

### 用自己的 Python 环境

```bat
pip install django==5.0 pymysql cryptography
```

`pymysql` 是 MySQL 驱动（纯 Python，不用编译），`cryptography` 是 MySQL 8
的密码认证要用的，少了它连接会报错。

### 关于 Python 版本（重要）

本项目在 **Python 3.12** 和 **Python 3.15** 上都测过，25 个页面（含后台）全部通过。

但 Python 3.15 有个坑：Django 5.0 的 `BaseContext.__copy__` 里写的是
`duplicate = copy(super())`，3.15 改变了 `copy(super())` 的行为，
导致**后台管理页面全部报 `AttributeError: 'super' object has no attribute 'dicts'`**。

解决办法已经在 `petcare/__init__.py` 里写好（`_patch_template_context_copy`）：
启动时先探测，真有问题才替换成等价实现。**在 3.12 上补丁不生效，不影响原生行为。**

推荐用 Python 3.12 跑；用 3.15 也能跑，补丁会自动兜底。

## 二、数据库

| 项目 | 值 |
| --- | --- |
| 类型 | MySQL 8.0 |
| 库名 | `petcare` |
| 账号 / 密码 | `petcare` / `petcare123` |
| 地址 | 127.0.0.1:3306 |
| 字符集 | utf8mb4 |

配置在 `petcare/settings.py` 的 `DATABASES`，详细说明见 [`database/README.md`](database/README.md)。

`database/` 目录里有三个 SQL 文件：

| 文件 | 用途 |
| --- | --- |
| `petcare_full.sql` | 建库 + 建表 + 数据，一份全搞定（推荐） |
| `petcare_schema.sql` | 只要表结构 |
| `petcare_data.sql` | 只要两张业务表的数据 |

## 三、演示账号

| 账号 | 密码 | 说明 |
| --- | --- | --- |
| `xiaoming` | `xm123456` | 普通用户，已录入 3 只宠物、5 条就诊记录 |
| `admin` | `admin123456` | 超级用户，可登录 `/admin/` 后台 |

## 四、页面地址

| 地址 | 页面 |
| --- | --- |
| `/` | 首页（统计 + 最近记录） |
| `/login/`、`/register/` | 登录、注册 |
| `/pet/` | 我的宠物（可搜索） |
| `/pet/add/`、`/pet/<id>/edit/` | 添加 / 修改宠物 |
| `/record/` | 就诊记录（可按状态筛选） |
| `/record/add/` | 添加就诊记录 |
| `/admin/` | 后台管理（用 admin 账号） |

## 五、代码在哪

| 功能 | 文件 |
| --- | --- |
| 两张表的定义 | `pets/models.py` |
| 表单与校验 | `pets/forms.py` |
| 所有页面逻辑 | `pets/views.py` |
| 网址配置 | `pets/urls.py` |
| 后台管理 | `pets/admin.py` |
| 页面模板 | `templates/`（`base.html` 是公共布局） |
| 样式 | `static/css/style.css` |
| 数据库 SQL | `database/` |
| MySQL 驱动配置 | `petcare/__init__.py`（`pymysql.install_as_MySQLdb()`） |

## 六、重置演示数据

改乱了想恢复，重新导一次 SQL：

```bat
mysql -u root -p < database\petcare_full.sql
```

或者只清空业务数据、保留表结构：

```bat
mysql -u petcare -ppetcare123 -D petcare -e "DELETE FROM sickness_record; DELETE FROM pet;"
..\myenv\Scripts\python.exe ..\tools\pet_seed.py
```

## 七、自动测试

```bat
..\myenv\Scripts\python.exe ..\tools\pet_smoke.py       :: 逐条访问所有路由
..\myenv\Scripts\python.exe ..\tools\pet_crud_demo.py   :: 完整增删改查
..\myenv\Scripts\python.exe ..\tools\pet_admin_check.py :: 后台可用性
```

## 八、相关文件

- `../report/课程设计报告-宠物生病管理系统.docx` —— 课程设计报告
- `../宠物系统-答辩讲解稿.md` —— 答辩时照着讲的稿子
- `../shots_pet/` —— 报告里用到的界面图、结构图、E-R 图