# 测试 Component.R（位于 R/temp/，非包导出，故需 source）
source(testthat::test_path("..", "..", "R", "temp", "Component.R"))

test_that("RemoveSeasonal：均值升序，异常序列去季节", {
  x <- c(1, 2, 3, 10, 20, 30)
  t <- c(101, 101, 101, 202, 202, 202)
  out <- RemoveSeasonal(x, t)

  expect_equal(out$mu, c(2, 20))
  expect_equal(out$anomaly, c(-1, 0, 1, -10, 0, 10))
  expect_length(out$anomaly, length(x))
})

test_that("LS_MultiBreaks：同斜率不同截距", {
  x <- 1:10
  y <- 2 * x + c(rep(1, 5), rep(5, 5))
  out <- LS_MultiBreaks(y, x, Ips = c(5, 10))

  expect_equal(as.vector(out$coef), c(12, 2, 4))
  expect_equal(out$fitted, y)
})

test_that("LS_OneBreak：单断点分段回归", {
  x <- 1:10
  y <- 2 * x + c(rep(1, 4), rep(3, 6))
  out <- LS_OneBreak(y, x, Ic = 4)

  expect_equal(as.vector(out$coef), c(1, 2, 2))
  expect_equal(out$fitted, y)
  expect_equal(out$SSE, 0)
})

test_that("lm_solve：系数与 SSE", {
  x <- 1:10
  y <- 2 * x + 1
  out <- lm_solve(cbind(1, x), y)

  expect_equal(as.vector(out$coef), c(1, 2))
  expect_equal(out$SSE, 0)
  expect_equal(lm_solve(cbind(1, x), y, only.SSE = TRUE)$SSE, 0)
})
