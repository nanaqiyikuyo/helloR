#import "@local/modern-cug-report:0.1.3": *
#show: doc => template(doc, footer: "CUG水文气象学2026", header: "作业 1.6：R 包开发流程")

= 1 目标

以 #link("https://github.com/rpkgs/rpkg.template")[rpkg.template] 为模板，
将 RHtests 的 Component.R 集成进 R 包，补齐文档与测试，
推送 GitHub 后由 CI 自动检查，2--3 min 即可看到结果。

= 2 操作步骤

== 2.1 克隆模板

```sh
git clone https://github.com/rpkgs/rpkg.template
```

改名为 helloR，修改 DESCRIPTION、README，推送到
#link("https://github.com/nanaqiyikuyo/helloR")[github.com/nanaqiyikuyo/helloR]。

== 2.2 添加函数

将 #link("https://github.com/rpkgs/RHtests/blob/master/R/Component.R")[Component.R]
复制到 `R/` 目录，分段回归模型为

$ y = a + b x + c I(x > I_c) $ <eq_1>

式中 `I_c` 为断点位置。引用式#[@eq_1]。

组件函数如表#[@table_func]所示。

#figure(
  caption: [Component.R 中的函数],
  table(
    columns: (auto, auto),
    align: (left, left),
    [函数], [功能],
    [`RemoveSeasonal`], [按月日求季节均值与去季节序列],
    [`LS_MultiBreaks`], [多断点分段回归（同斜率、不同截距）],
    [`LS_OneBreak`], [单断点分段回归],
    [`lm_solve`], [基于 `.lm.fit` 的最小二乘求解],
  ),
) <table_func>

== 2.3 编写文档与测试

用 roxygen2 注释（`#'`）编写函数文档，并生成测试代码：

```R
test_that("RemoveSeasonal：均值升序，异常序列去季节", {
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

模板自带三条工作流：`R-CMD-check`（Windows + Ubuntu 双平台检查）、
`test-coverage`（covr 覆盖率）、`pkgdown`（文档站点）。

#figure(
  image("Figures/AI/Figure1_CI流程.png", width: 100%),
  caption: [GitHub Actions CI 运行结果。],
) <fig_ci>

CI 运行结果如图#[@fig_ci]所示，提交后约 2--3 min 出结果。

== 2.5 编译生成 PDF

本笔记由 Typst 编写，用 Tinymist 编译为 PDF：

```sh
cd docs
tinymist compile homework_01.typ --root .
```

产物为 `homework_01.pdf`。若已安装 typst CLI，也可用
`typst compile homework_01.typ`。

= 3 存在的问题

1. 函数未随包编译：Component.R 起初不在 `R/` 下，CI 测试失败；
   移入包内后通过。
2. codecov 上传失败：无 token 时报错，将 `fail_ci_if_error`
   置为 false 后不再阻塞 CI。
3. pkgdown 部署无写权限：给 workflow 增加 `contents: write` 权限。

= 4 总结

本次作业走通了一套完整的 R 包开发流程：从模板克隆、函数集成、
roxygen2 文档、testthat 测试，到 GitHub Actions 持续集成。

收获：

- 掌握 rpkg.template 的目录结构与工作流约定
- 学会用 roxygen2 编写函数文档并生成 `man/*.Rd` 与 NAMESPACE
- 学会用 testthat 为回归函数编写测试（12 项全部通过）
- 理解 CI 的反馈闭环：推送后 2--3 min 即可定位并修复问题

不足：

- 包名仍为 `rpkg.template`，未按项目重命名
- DESCRIPTION 的 Title 与 Description 仍是模板占位文本
- `RemoveSeasonal` 缺少 roxygen 注释，未生成对应文档

