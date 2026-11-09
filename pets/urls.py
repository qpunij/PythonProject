"""pets 应用的路由"""
from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),

    # 用户
    path('register/', views.register, name='register'),
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),

    # 宠物
    path('pet/', views.pet_list, name='pet_list'),
    path('pet/add/', views.pet_add, name='pet_add'),
    path('pet/<int:pk>/edit/', views.pet_edit, name='pet_edit'),
    path('pet/<int:pk>/delete/', views.pet_delete, name='pet_delete'),

    # 就诊记录
    path('record/', views.record_list, name='record_list'),
    path('record/add/', views.record_add, name='record_add'),
    path('record/add/<int:pet_id>/', views.record_add, name='record_add_for_pet'),
    path('record/<int:pk>/edit/', views.record_edit, name='record_edit'),
    path('record/<int:pk>/delete/', views.record_delete, name='record_delete'),
]