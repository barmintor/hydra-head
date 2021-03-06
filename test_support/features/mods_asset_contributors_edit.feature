@contributors
Feature: Edit Article Contributors
  As a person with edit permissions
  In order to manage the contributor entries (names) in a MODS document
  I want to see and edit the contributors associated with an article

  Scenario: Viewing contributors in edit mode
    Given I am logged in as "archivist1@example.com" 
    And I am on the edit document page for hydrangea:fixture_mods_article1 
    Then the "First Name" field should contain "GIVEN NAMES"
    And the "Last Name" field should contain "FAMILY NAME"
    # And I should see "Author" within "select[rel=person_0_role_text]"
    # And the "role" field for "the 1st person" entry should contain "Author"
    And the "Institution" field should contain "FACULTY, UNIVERSITY"
    # And I should see a delete contributor button for "the 1st person entry in hydrangea:fixture_mods_article1" # first person entry is not deletable
    
    # Then the "First Name" field for "person_1" should contain "Henrietta"
    # And the "Last Name" field for "person_1" should contain "Lacks"
    # And the "Role" field for "person_1" should contain "Contributor"
    # And the "Institution" field for "person_1" should contain "Baltimore"
    Then the "First Name" field within "#person_1" should contain "Henrietta"
    And the "Last Name" field within "#person_1" should contain "Lacks"
    # And I should see "Contributor" within "select[rel=person_1_role_text]" # Author roles are implicit
    And the "Institution" field within "#person_1" should contain "Baltimore"
    And I should see a delete contributor button for "the 2nd person entry in hydrangea:fixture_mods_article1"

  @local
  Scenario: Viewing contributors in edit mode
    Given I am logged in as "archivist1@example.com"
    And I am on the edit document page for libra-oa:1 
    Then the "First Name" field should contain "Mary"
    And the "Last Name" field should contain "Gibson"
    And the "Institution" field should contain "University of Virginia"

  Scenario: Viewing contributors in browse mode
    Given I am logged in as "archivist1@example.com"
    And I am on the show document page for hydrangea:fixture_mods_article1 
    Then I should see "GIVEN NAMES" within "#contributors_list"
    And I should see "FAMILY NAME" within "#contributors_list"
    # And I should see "Creator" within "#contributor_role" # Authors role is implicit
    # And the "role" field for "the 1st person" entry should contain "Author"
    And I should see "FACULTY, UNIVERSITY" within "#contributors_list"
    And I should not see a delete contributor button for "the 1st person entry in hydrangea:fixture_mods_article1"

    # Then the "First Name" field for "person_1" should contain "Henrietta"
    # And the "Last Name" field for "person_1" should contain "Lacks"
    # And the "Role" field for "person_1" should contain "Contributor"
    # And the "Institution" field for "person_1" should contain "Baltimore"
    Then I should see "Henrietta"
    And I should see "Lacks"
    # And I should see "Contributor" within "#person_1 #contributor_role" # Authors role is implicit
    And I should see "Baltimore"
    And I should not see a delete contributor button for "the 2nd person entry in hydrangea:fixture_mods_article1"

    # The following 6 lines are commented out due to the organization being removed from the contributors forms in the Mods Asset Workflow document
    #Then the "organization_0_namePart" field should contain "NSF"
    #And I should see "Funder" within "#organization_0"    
    #And I should not see a delete contributor button for "the 1st organization entry in hydrangea:fixture_mods_article1"

    #Then I should see "some conference"
    #And I should see "Host" within "#conference_0"    
    #And I should not see a delete contributor button for "the 1st conference entry in hydrangea:fixture_mods_article1"

  @local
  Scenario: Viewing contributors in browse mode
    Given I am logged in as "archivist1@example.com"
    And I am on the show document page for libra-oa:1
    Then I should see "Mary Gibson" within "#contributors_list"
    And I should see "Author" within ".contributor_role"
    And I should see "University of Virginia" within "#contributors_list"
    And I should not see a delete contributor button for "the 1st person entry in libra-oa:1"
    
  Scenario: Deleting contributors
    Given I am logged in as "archivist1@example.com"
    When I am on the edit contributor page for libra-oa:1
    And I press "Add Another Author"
    When I fill in "person_1_computing_id" with "012345"
    And I fill in "person_1_first_name" with "Jane"
    And I fill in "person_1_last_name" with "Dough"
    Then the "person_1_last_name" field within "#person_1" should contain "Dough"
    And I fill in "person_1_description" with "Pizza Chef"
    And I fill in "person_1_institution" with "Academy for Aspiring Young Pizza Chefs"
    When I press "Continue"
    And I am on the edit contributor page for libra-oa:1
    Then the "person_1_last_name" field within "#person_1" should contain "Dough"
    When I follow "Delete"
    And I press "Continue"
    Then I should not see "Dough"
