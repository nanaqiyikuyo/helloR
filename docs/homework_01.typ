#import "@local/modern-cug-report:0.1.3": *
#show: doc => template(doc, footer: "CUG水文气象学2026", header: "")
           
= 1 目标

 以#link("https://github.com/rpkgs/rpkg.template")[rpkg
   .template] 为模板，
 将 RHtests 的 Component.R 集成进 R 包，补齐文档与
 测试，
 推送 GitHub 后由 CI 自动检查，2--3 min 即可看到结
 果。

= 2 操作步骤

== 2.1 克隆模板

```sh
  git clone https://github.com/rpkgs/rpkg.template   
```

改名为 helloR，修改 DESCRIPTION、README，推送到
#link("https://github.com/nanaqiyikuyo/helloR")[gith
  ub.com/nanaqiyikuyo/helloR]。 

  == 2.2 添加函数

  将
  #link("https://github.com/rpkgs/RHtests/blob/master/R/Component.R")[Component.R]
  复制到 R/ 目录，分段回归模型为

  $ y = a + b x + c I(x > I_c) $ <eq_1>

  式中 I_c 为断点位置。引用式#[@eq_1]。

  组件函数如表#[@table_func]所示。

  #figure(
    caption: [Component.R 中的函数],
    table(
      columns: (auto, auto),
      align: (left, left),
      [函数], [功能],
      [RemoveSeasonal],
      [按月日求季节均值与去季节序列
      ],

      [LS_MultiBreaks],
      [多断点分段回归（同斜率、不同
        截距）],

      [LS_OneBreak], [单断点分段回归],
      [lm_solve], [基于 .lm.fit 的最小二乘求解],
    ),
  ) <table_func>
  == 2.3 编写文档与测试                                
                                                      
 编写函数文档，并生成测试代码： 
                                                      
 ```R                                                 
   test_that("RemoveSeasonal：均值升序，异常序列去季  
 节", {                                               
     x <- c(1, 2, 3, 10, 20, 30)                      
     t <- c(101, 101, 101, 202, 202, 202)             
     out <- RemoveSeasonal(x, t)                      
     expect_equal(out$mu, c(2, 20))                   
   })                                                 
 ```                                                  
                                                      
 == 2.4 推送 GitHub 触发 CI                           
                                                      
 ```sh                                                
   git push origin main                               
 ```                                                  
                                                      
 模板自带三条工作流：R-CMD-check（Windows + Ubuntu 双 
 平台检查）、                                         
 test-coverage（covr 覆盖率）、pkgdown（文档站点）。  
                                                      
 #figure(                                             
   image("figure/168b2e13-2c9e-4a9b-bc72-f534016aa1e3.png", width:      
 100%),                                               
   caption: [GitHub Actions CI 运行结果。],           
 ) <fig_ci>                                           
                                                      
 CI 运行结果如图#[@fig_ci]所示，提交后约 2--3 min 出  
 结果。
 == 2.5 编译生成 PDF

 本笔记由 Typst 编写，用 Tinymist 编译为 PDF：

 ```sh
   cd docs                                            
   tinymist compile homework_01.typ --root .          
 ```

 产物为 homework_01.pdf。若已安装 typst CLI，也可用
 typst compile homework_01.typ。

 = 3 存在的问题

 1. 函数未随包编译：Component.R 起初不在 R/ 下，CI 测
   试失败；
   移入包内后通过。
 2. codecov 上传失败：无 token 时报错，将
   fail_ci_if_error
   置为 false 后不再阻塞 CI。
 3. pkgdown 部署无写权限：给 workflow 增加 contents:
   write 权限。
