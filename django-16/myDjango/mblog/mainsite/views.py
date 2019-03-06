from django.shortcuts import render
from django.template.loader import get_template
from .models import Post
from django.shortcuts import redirect
from datetime import datetime
from django.http import  HttpResponse
# Create your views here.
def homepage(request):
    template = get_template('index.html')
    posts = Post.objects.all()
    now = datetime.now()
    html = template.render(locals())
    #post_lists = list()
    #for a,b in enumerate(posts):
     #   post_lists.append("no.{}".format(str(a))+str(b)+"<br>")
    return HttpResponse(html)
def showpost(request,slug):
    template = get_template('post.html')
    try:
        post = Post.objects.get(slug=slug)
        if post != None:
            html=template.render(locals())
            return HttpResponse(html)
    except:
        return redirect('/')


