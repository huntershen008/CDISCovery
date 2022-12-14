context("table generator ANOVA block")

test_that("ANOVA block ADSL group", {
  app_anova.ADSL("AGE", NULL, "SEX", tg_data)
})

test_that("ANOVA block BDS group", {
  app_anova.BDS("DIABP", "Week 2", "SEX", tg_data)
})

# -------------------------------------------
# Expected Test Failures
# -------------------------------------------

test_that("ANOVA block ADSL without group fails", {
  expect_error(app_anova.ADSL(AGE, NULL, NULL, tg_data))
})

test_that("ANOVA block BDS without group fails", {
  expect_error(app_anova.BDS("DIABP", "Week 2", NULL, tg_data))
})

test_that("ANOVA block OCCDS exits", {
  expect_error(app_ANOVA.OCCDS("DIABP", "Week 2", "SEX", tg_data))
})

test_that("ANOVA block default exits", {
  expect_error(app_ANOVA.default("DIABP", "Week 2", "SEX", tg_data))
})
