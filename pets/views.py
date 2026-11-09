"""宠物生病管理系统 —— 视图"""
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from django.shortcuts import get_object_or_404, redirect, render

from .forms import PetForm, SicknessRecordForm
from .models import Pet, SicknessRecord


def register(request):
    """用户注册"""
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, '注册成功，请登录')
            return redirect('login')
    else:
        form = UserCreationForm()
    return render(request, 'pets/register.html', {'form': form})


def login_view(request):
    """用户登录"""
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('index')
        error = '用户名或密码错误'
        return render(request, 'pets/login.html', {'error': error,
                                                   'username': username})
    return render(request, 'pets/login.html')


def logout_view(request):
    """退出登录"""
    logout(request)
    return redirect('login')


@login_required
def index(request):
    """首页：统计信息 + 最近的生病记录"""
    pets = Pet.objects.filter(owner=request.user)
    records = SicknessRecord.objects.filter(pet__owner=request.user)
    context = {
        'pet_count': pets.count(),
        'sick_count': records.filter(status='治疗中').count(),
        'cured_count': records.filter(status='已痊愈').count(),
        'total_cost': sum(r.cost for r in records),
        'recent': records[:5],
    }
    return render(request, 'pets/index.html', context)


@login_required
def pet_list(request):
    """我的宠物列表，支持按名字搜索"""
    keyword = request.GET.get('keyword', '').strip()
    pets = Pet.objects.filter(owner=request.user)
    if keyword:
        pets = pets.filter(name__contains=keyword)
    return render(request, 'pets/pet_list.html', {'pets': pets, 'keyword': keyword})


@login_required
def pet_add(request):
    """添加宠物"""
    if request.method == 'POST':
        form = PetForm(request.POST)
        if form.is_valid():
            pet = form.save(commit=False)
            pet.owner = request.user
            pet.save()
            messages.success(request, '添加成功')
            return redirect('pet_list')
    else:
        form = PetForm()
    return render(request, 'pets/pet_form.html', {'form': form, 'title': '添加宠物'})


@login_required
def pet_edit(request, pk):
    """修改宠物信息"""
    pet = get_object_or_404(Pet, pk=pk, owner=request.user)
    if request.method == 'POST':
        form = PetForm(request.POST, instance=pet)
        if form.is_valid():
            form.save()
            messages.success(request, '修改成功')
            return redirect('pet_list')
    else:
        form = PetForm(instance=pet)
    return render(request, 'pets/pet_form.html', {'form': form, 'title': '修改宠物'})


@login_required
def pet_delete(request, pk):
    """删除宠物（连同它的就诊记录一起删掉）"""
    pet = get_object_or_404(Pet, pk=pk, owner=request.user)
    if request.method == 'POST':
        pet.delete()
        messages.success(request, '删除成功')
        return redirect('pet_list')
    return render(request, 'pets/confirm_delete.html',
                  {'title': '删除宠物', 'object': pet,
                   'back_url': 'pet_list'})


@login_required
def record_list(request):
    """就诊记录列表，支持按状态筛选"""
    status = request.GET.get('status', '')
    records = SicknessRecord.objects.filter(pet__owner=request.user)
    if status:
        records = records.filter(status=status)
    return render(request, 'pets/record_list.html',
                  {'records': records, 'status': status})


@login_required
def record_add(request, pet_id=None):
    """添加就诊记录（可以从某个宠物直接点进来）"""
    initial = {}
    if pet_id:
        initial['pet'] = get_object_or_404(Pet, pk=pet_id, owner=request.user)
    if request.method == 'POST':
        form = SicknessRecordForm(request.POST, user=request.user)
        if form.is_valid():
            form.save()
            messages.success(request, '记录添加成功')
            return redirect('record_list')
    else:
        form = SicknessRecordForm(initial=initial, user=request.user)
    return render(request, 'pets/record_form.html',
                  {'form': form, 'title': '添加就诊记录'})


@login_required
def record_edit(request, pk):
    """修改就诊记录"""
    record = get_object_or_404(SicknessRecord, pk=pk, pet__owner=request.user)
    if request.method == 'POST':
        form = SicknessRecordForm(request.POST, instance=record, user=request.user)
        if form.is_valid():
            form.save()
            messages.success(request, '修改成功')
            return redirect('record_list')
    else:
        form = SicknessRecordForm(instance=record, user=request.user)
    return render(request, 'pets/record_form.html',
                  {'form': form, 'title': '修改就诊记录'})


@login_required
def record_delete(request, pk):
    """删除就诊记录"""
    record = get_object_or_404(SicknessRecord, pk=pk, pet__owner=request.user)
    if request.method == 'POST':
        record.delete()
        messages.success(request, '删除成功')
        return redirect('record_list')
    return render(request, 'pets/confirm_delete.html',
                  {'title': '删除就诊记录', 'object': record,
                   'back_url': 'record_list'})