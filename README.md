# 宠物生病管理系统（Django）

《PythonWeb程序设计》课程设计 —— 基于 Django 的宠物生病管理系统。

## 一、怎么跑起来

已经配好虚拟环境，直接在项目目录执行：

```bat
cd petcare
..\myenv\Scripts\python.exe manage.py runserver
```

浏览器打开 <http://127.0.0.1:8000/>。

如果你用自己的 Python（比如 PyCharm 里的解释器），先装依赖再跑：

```bat
pip install django==5.0
cd petcare
python manage.py migrate
python manage.py runserver
```

## 二、演示账号

| 账号 | 密码 | 说明 |
| --- | --- | --- |
| `xiaoming` | `xm123456` | 普通用户，已录入 3 只宠物、5 条就诊记录 |
| `admin` | `admin123456` | 超级用户，可登录 `/admin/` 后台 |

## 三、页面地址

| 地址 | 页面 |
| --- | --- |
| `/` | 首页（统计 + 最近记录） |
| `/login/`、`/register/` | 登录、注册 |
| `/pet/` | 我的宠物（可搜索） |
| `/pet/add/`、`/pet/<id>/edit/` | 添加 / 修改宠物 |
| `/record/` | 就诊记录（可按状态筛选） |
| `/record/add/` | 添加就诊记录 |
| `/admin/` | 后台管理 |

## 四、代码在哪

| 功能 | 文件 |
| --- | --- |
| 两张表的定义 | `pets/models.py` |
| 表单与校验 | `pets/forms.py` |
| 所有页面逻辑 | `pets/views.py` |
| 网址配置 | `pets/urls.py` |
| 后台管理 | `pets/admin.py` |
| 页面模板 | `templates/`（`base.html` 是公共布局） |
| 样式 | `static/css/style.css` |

## 五、重置演示数据

```bat
cd petcare
del db.sqlite3
..\myenv\Scripts\python.exe manage.py migrate
..\myenv\Scripts\python.exe ..\tools\pet_seed.py
```

## 六、自动测试

```bat
..\myenv\Scripts\python.exe ..\tools\pet_smoke.py
```

会逐条访问所有路由并打印状态码（200 正常、302 跳转），同时测试增删改查。

## 七、相关文件

- `../report/课程设计报告-宠物生病管理系统.docx` —— 课程设计报告
- `../宠物系统-答辩讲解稿.md` —— 答辩时照着讲的稿子
- `../shots_pet/` —— 报告里用到的界面图、结构图、E-R 图