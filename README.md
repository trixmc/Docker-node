# Create container
```
docker run -it -d --name=node -h=node -p 1080:80 -p 1022:22 trixmc/docker-node /bin/bash
```
```
docker run -it -d --name=node -h=node -v /local/code/dir:/var/www -p 1080:80 -p 1022:22 trixmc/docker-node /bin/bash
```
# SSH as docker user in Groups: www-data,sudo
```
ssh -p1022 docker@localhost
password: docker
```
# SSH as root user
```
ssh -p1022 root@localhost
password: root
```

# NGINX  user IP over proxy
For getting user IP over proxy you need to edit /etc/nginx/fastcgi_params
Change this:
```
fastcgi_param   REMOTE_ADDR     $remote_addr;
```
To this:
```
fastcgi_param   REMOTE_ADDR             $http_x_real_ip;
``` 
And do not forget to reload nginx
```
service nginx reload
```