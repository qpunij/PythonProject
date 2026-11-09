"""宠物生病管理系统 —— 后台管理"""
from django.contrib import admin

from .models import Pet, SicknessRecord


@admin.register(Pet)
class PetAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'species', 'gender', 'age', 'owner', 'created']
    list_filter = ['species', 'gender']
    search_fields = ['name', 'owner__username']
    list_per_page = 10


@admin.register(SicknessRecord)
class SicknessRecordAdmin(admin.ModelAdmin):
    list_display = ['id', 'pet', 'disease', 'visit_date', 'cost', 'status']
    list_filter = ['status', 'visit_date']
    search_fields = ['pet__name', 'disease']
    list_per_page = 10
    date_hierarchy = 'visit_date'