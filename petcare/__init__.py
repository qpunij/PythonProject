"""petcare 项目包。

这里做两件事：
1. Django 默认用 mysqlclient 连 MySQL，本机没装编译环境，
   改用纯 Python 的 PyMySQL 代替，不影响 ORM 的用法。
2. 给 Django 的模板上下文复制打一个兼容补丁（只在有问题的 Python 版本上生效）。
"""
import pymysql

pymysql.install_as_MySQLdb()


def _patch_template_context_copy():
    """兼容补丁：修 Django 在 Python 3.15 上的模板上下文复制问题。

    Django 5.0 的 BaseContext.__copy__ 是这样写的：

        from copy import copy
        def __copy__(self):
            duplicate = copy(super())
            duplicate.dicts = self.dicts[:]
            return duplicate

    它依赖 copy(super()) 返回一个可赋值的对象：
      - 在 Python 3.12 上，copy(super()) 返回的是 self 所属类的实例副本，正常；
      - 在 Python 3.15 上，返回的却是 super 对象本身，于是第二行抛
        AttributeError: 'super' object has no attribute 'dicts'。
    后台管理页面（模板里用了 inclusion_tag）会直接 500。

    这里先按同样的写法探测一次：没问题就什么都不做；
    真有问题才把 __copy__ 换成等价的实现（用 __new__ 造空对象再复制属性）。
    """
    from copy import copy as _copy      # 必须是函数，和 Django 的用法保持一致

    try:
        class _Probe:
            def __init__(self):
                self.dicts = []

            def __copy__(self):
                duplicate = _copy(super())
                duplicate.dicts = self.dicts[:]
                return duplicate

        _copy(_Probe())
        return False                      # 当前版本没问题，不打补丁
    except Exception:
        pass

    from django.template import context as _ctx

    def __copy__(self):
        duplicate = self.__class__.__new__(self.__class__)
        duplicate.__dict__.update(self.__dict__)
        duplicate.dicts = self.dicts[:]
        return duplicate

    _ctx.BaseContext.__copy__ = __copy__
    return True


_PATCHED = _patch_template_context_copy()