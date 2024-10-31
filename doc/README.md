## 应用进入

### 启动页

初始化 Dio ，添加Cookie Manager，实现会话管理

_initializeDio : 初始化Dio，添加会话管理

存储中获取Token，发送post请求，检验 Token 存活

- **BaseUrl :**  基础地址
- **loginWithTokenUrl :**  Token 登录接口

|     功能      | 请求类型 | 参数  |     要求     |
| :-----------: | :------: | :---: | :----------: |
| Token自动登录 |   post   | token | 返回用户信息 |



------

### 账号密码登录界面

|   账号    |   密码    |  验证码   |
| :-------: | :-------: | :-------: |
|  account  | password  |  capcha   |
| TextField | TextField | TextField |

- **captchaImageUrl :** 图形验证码获取接口
- **accountLoginUrl :**  账号密码登录接口
- **_captchaController :** 验证码输入框控制器
- **_passwordController :**  密码输入框控制器
- **_usernameController :**  账号输入框控制器
- **_usernameFocusNode** 、**_passwordFocusNode**、**_captchaFocusNode** : 输入框焦点

|       功能       | 请求类型 |         参数          |          要求           |
| :--------------: | -------- | :-------------------: | :---------------------: |
| 初始化图像验证码 | get      |           -           |  responseType为字节流   |
|  更新图形验证码  | get      |       timestamp       |  responseType为字节流   |
|   账号密码登录   | post     | account,password,code | 返回用户所有信息和token |



### 邮箱验证码登录界面

|   邮箱    |  验证码   |
| :-------: | :-------: |
|   email   | emailCode |
| TextField | TextField |

- **getEmailCodeUrl :** 邮箱验证码获取接口

- **loginWithEmailCodeUrl :** 邮箱验证码登录接口
- **_emailController**、**_codeController** : 输入框控制器
- **_emailFocusNode**、**_codeFocusNode** : 输入框焦点
- **_timer** : 获取验证码计时器

|      功能      | 请求类型 |      参数       |          要求           |
| :------------: | :------: | :-------------: | :---------------------: |
| 获取邮箱验证码 |   get    |      email      | 后端对邮箱判断是否注册  |
| 邮箱验证码登录 |   post   | email,emailCode | 返回用户所有信息和token |



### 手机验证码登录界面

|  手机号   |  验证码   |
| :-------: | :-------: |
|   phone   | phoneCode |
| TextField | TextField |

- **getPhoneCodeUrl :** 邮箱验证码获取接口

- **loginWithPhoneCodeUrl :** 邮箱验证码登录接口

- **_phoneController**、**_codeController** : 输入框控制器

- **_phoneFocusNode**、**_codeFocusNode** : 输入框焦点

- **_phoneFocusNode**、**_codeFocusNode** : 输入框焦点

|      功能      | 请求类型 |      参数       |          要求           |
| :------------: | :------: | :-------------: | :---------------------: |
| 获取手机验证码 |   get    |      phone      | 后端对手机判断是否注册  |
| 手机验证码登录 |   post   | phone,phoneCode | 返回用户所有信息和token |

------

### 注册

#### 邮箱验证码注册界面

|   邮箱    |  验证码   |
| :-------: | :-------: |
|   email   | emailCode |
| TextField | TextField |

- **registerEmail** : 注册邮箱（全局变量）
- **getRegisterEmailCodeUrl : ** 邮箱验证码获取接口

- **registerCheckEmailCodeUrl :** 邮箱验证码检验接口

- **_emailController**、**_codeController** : 输入框控制器
- **_emailFocusNode**、**_codeFocusNode** : 输入框焦点
- **_timer** : 获取验证码计时器

|      功能      | 请求类型 |      参数       |          要求          |
| :------------: | :------: | :-------------: | :--------------------: |
| 获取邮箱验证码 |   get    |      email      | 后端对邮箱判断是否注册 |
| 邮箱验证码注册 |   post   | email,emailCode |      返回检验结果      |



#### 手机验证码注册界面

|  手机号   |  验证码   |
| :-------: | :-------: |
|   phone   | phoneCode |
| TextField | TextField |

- **registerPhone** : 注册邮箱（全局变量）
- **getRegisterPhoneCodeUrl :** 手机验证码获取接口
- **registerCheckPhoneCodeUrl :** 手机验证码检验接口
- **_phoneController**、**_codeController** : 输入框控制器
- **_phoneFocusNode**、**_codeFocusNode** : 输入框焦点
- **_timer** : 获取验证码计时器

|      功能      | 请求类型 |      参数       |          要求          |
| :------------: | :------: | :-------------: | :--------------------: |
| 获取手机验证码 |   get    |      phone      | 后端对手机判断是否注册 |
| 手机验证码登录 |   post   | phone,phoneCode |      返回检验结果      |



#### 密码确认界面

|   密码    | 二次输入密码  |
| :-------: | :-----------: |
| password  | checkPassword |
| TextField |   TextField   |

- **_passwordController**、**_checkPasswordController** : 输入框控制器

- **_passwordFocusNode**、**_checkPasswordFocusNode** : 输入框焦点
- **registerWithEmailUrl :** 邮箱注册接口
- **registerWithPhoneUrl :** 手机注册接口

|    功能    | 请求类型 |      参数       |                 要求                 |
| :--------: | :------: | :-------------: | :----------------------------------: |
| 手机号注册 |   post   | phone，password | 后端对手机注册账号并返回注册成功的类 |
|  邮箱注册  |   post   | email，password | 后端对邮箱注册账号并返回注册成功的类 |

------