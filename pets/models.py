"""宠物生病管理系统 —— 数据模型"""
from django.contrib.auth.models import User
from django.db import models


class Pet(models.Model):
    """宠物基本信息表"""
    SPECIES_CHOICES = (
        ('猫', '猫'),
        ('狗', '狗'),
        ('兔', '兔'),
        ('仓鼠', '仓鼠'),
        ('鸟', '鸟'),
        ('鱼', '鱼'),
        ('其他', '其他'),
    )
    GENDER_CHOICES = (
        ('公', '公'),
        ('母', '母'),
    )

    owner = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='主人')
    name = models.CharField('宠物名', max_length=20)
    species = models.CharField('种类', max_length=10, choices=SPECIES_CHOICES, default='猫')
    gender = models.CharField('性别', max_length=2, choices=GENDER_CHOICES, default='公')
    age = models.PositiveIntegerField('年龄(岁)', default=1)
    weight = models.DecimalField('体重(kg)', max_digits=5, decimal_places=2, default=0)
    created = models.DateTimeField('录入时间', auto_now_add=True)

    class Meta:
        db_table = 'pet'
        verbose_name = '宠物'
        verbose_name_plural = verbose_name
        ordering = ['-created']

    def __str__(self):
        return self.name


class SicknessRecord(models.Model):
    """宠物生病就诊记录表"""
    STATUS_CHOICES = (
        ('治疗中', '治疗中'),
        ('已痊愈', '已痊愈'),
    )

    pet = models.ForeignKey(Pet, on_delete=models.CASCADE, verbose_name='宠物')
    disease = models.CharField('病名', max_length=30)
    symptom = models.TextField('症状描述', blank=True)
    visit_date = models.DateField('就诊日期')
    hospital = models.CharField('就诊医院', max_length=50, blank=True)
    medicine = models.CharField('用药', max_length=100, blank=True)
    cost = models.DecimalField('花费(元)', max_digits=8, decimal_places=2, default=0)
    status = models.CharField('治疗状态', max_length=10,
                              choices=STATUS_CHOICES, default='治疗中')
    created = models.DateTimeField('记录时间', auto_now_add=True)

    class Meta:
        db_table = 'sickness_record'
        verbose_name = '就诊记录'
        verbose_name_plural = verbose_name
        ordering = ['-visit_date', '-id']

    def __str__(self):
        return '%s - %s' % (self.pet.name, self.disease)