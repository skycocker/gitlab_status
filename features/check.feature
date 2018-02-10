Feature: Check
  Scenario: Validating gitlab.com response time
    When I run `gitlab_status check`
    Then the output should match /^success.*|failure.*/
