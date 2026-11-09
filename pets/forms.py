"""宠物生病管理系统 —— 表单"""
from django import forms

from .models import Pet, SicknessRecord


class PetForm(forms.ModelForm):
    """宠物信息表单"""

    class Meta:
        model = Pet
        fields = ['name', 'species', 'gender', 'age', 'weight']
        widgets = {
            'name': forms.TextInput(attrs={'placeholder': '例如：豆豆'}),
            'age': forms.NumberInput(attrs={'min': 0}),
            'weight': forms.NumberInput(attrs={'step': '0.01', 'min': 0}),
        }


class SicknessRecordForm(forms.ModelForm):
    """就诊记录表单"""

    class Meta:
        model = SicknessRecord
        fields = ['pet', 'disease', 'symptom', 'visit_date', 'hospital',
                  'medicine', 'cost', 'status']
        widgets = {
            'symptom': forms.Textarea(attrs={'rows': 3,
                                             'placeholder': '例如：不吃东西、精神差'}),
            'visit_date': forms.DateInput(attrs={'type': 'date'}),
            'disease': forms.TextInput(attrs={'placeholder': '例如：肠胃炎'}),
            'hospital': forms.TextInput(attrs={'placeholder': '例如：市宠物医院'}),
            'medicine': forms.TextInput(attrs={'placeholder': '例如：益生菌'}),
        }

    def __init__(self, *args, user=None, **kwargs):
        super().__init__(*args, **kwargs)
        # 只能给自己名下的宠物记录病情
        if user is not None:
            self.fields['pet'].queryset = Pet.objects.filter(owner=user)