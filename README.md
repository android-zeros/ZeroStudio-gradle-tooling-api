

# ZeroStudio Gradle Tooling API - Republished


Gradle Tooling API, republished on OSSRH.

**说明：本项目来自于 `https://github.com/AndroidIDEOfficial/gradle-tooling-api` ，新增批量下载的shell脚本，
用于批量下载全部gradle-tooling-api资源文件，同时只要配置完善也可以批量上传到maven仓库

全部资源的整体大小：2.70gb

**新增脚本：
zerostudio-gradle-tooling-api.sh
Delete0bFile.sh

''新增脚本增加批量下载，队列版本（下载指定多个版本），空文件验证与检查，已存在文件检查等
然后批量修改等

#使用方法：
将toml文件中的sdk更新：
```toml
gradle-tooling = "8.6"
tooling-gradleApi = { module = "com.itsaky.androidide.gradle:gradle-tooling-api", version.ref = "gradle-tooling" }
```
将：`com.itsaky.androidide.gradle:gradle-tooling-api`
替换为：
```code
io.github.android-zeros:gradle-tooling-api
```
然后更新需要的版本：`gradle-tooling = "\｀{version}｀"\ `

pom：
```xml
<dependency>
  <groupId>io.github.android-zeros</groupId>
  <artifactId>gradle-tooling-api</artifactId>
  <version>{你需要的版本}</version>
</dependency>
```

``示范下载链接： https://maven.pkg.github.com/android-zeros/ZeroStudio-gradle-tooling-api/io/github/android-zeros/gradle-tooling-api/3.2-rc-3/gradle-tooling-api-3.2-rc-3.jar


English translation: **Description: This project comes from 'https://github.com/AndroidIDEOfficial/gradle-tooling-api', adding shell scripts downloaded in batches,
It is used to download all gradle-tooling-api resource files in batches, and can also be uploaded to the Maven repository in batches as long as the configuration is perfect

Overall size of all resources: 2.70GB

**New script:
zerostudio-gradle-tooling-api.sh
Delete0bFile.sh

Added scripts such as batch download, queue version (download multiple versions), empty file verification and checking, existing file check, etc
Then batch modifications, etc


#How to use:
Update the SDK in the toml file:
```toml
gradle-tooling = "8.6"
tooling-gradleApi = { module = "com.itsaky.androidide.gradle:gradle-tooling-api", version.ref = "gradle-tooling" }
```
will：`com.itsaky.androidide.gradle:gradle-tooling-api`
replaced with：
```code
io.github.android-zeros:gradle-tooling-api
```
Then update the required version：`gradle-tooling = "\｀{version}｀"\ `

pom：
```xml
<dependency>
  <groupId>io.github.android-zeros</groupId>
  <artifactId>gradle-tooling-api</artifactId>
  <version>{The version you need:}</version>
</dependency>
```

``Demonstration download link： https://maven.pkg.github.com/android-zeros/ZeroStudio-gradle-tooling-api/io/github/android-zeros/gradle-tooling-api/3.2-rc-3/gradle-tooling-api-3.2-rc-3.jar
