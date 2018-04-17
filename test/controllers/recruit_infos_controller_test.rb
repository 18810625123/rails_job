require 'test_helper'

class RecruitInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recruit_info = recruit_infos(:one)
  end

  test "should get index" do
    get recruit_infos_url
    assert_response :success
  end

  test "should get new" do
    get new_recruit_info_url
    assert_response :success
  end

  test "should create recruit_info" do
    assert_difference('RecruitInfo.count') do
      post recruit_infos_url, params: { recruit_info: { checksum: @recruit_info.checksum, city_id: @recruit_info.city_id, company_id: @recruit_info.company_id, delivery_email: @recruit_info.delivery_email, end_at: @recruit_info.end_at, jd: @recruit_info.jd, job_city: @recruit_info.job_city, job_nature: @recruit_info.job_nature, job_title: @recruit_info.job_title, source: @recruit_info.source, start_at: @recruit_info.start_at, target: @recruit_info.target } }
    end

    assert_redirected_to recruit_info_url(RecruitInfo.last)
  end

  test "should show recruit_info" do
    get recruit_info_url(@recruit_info)
    assert_response :success
  end

  test "should get edit" do
    get edit_recruit_info_url(@recruit_info)
    assert_response :success
  end

  test "should update recruit_info" do
    patch recruit_info_url(@recruit_info), params: { recruit_info: { checksum: @recruit_info.checksum, city_id: @recruit_info.city_id, company_id: @recruit_info.company_id, delivery_email: @recruit_info.delivery_email, end_at: @recruit_info.end_at, jd: @recruit_info.jd, job_city: @recruit_info.job_city, job_nature: @recruit_info.job_nature, job_title: @recruit_info.job_title, source: @recruit_info.source, start_at: @recruit_info.start_at, target: @recruit_info.target } }
    assert_redirected_to recruit_info_url(@recruit_info)
  end

  test "should destroy recruit_info" do
    assert_difference('RecruitInfo.count', -1) do
      delete recruit_info_url(@recruit_info)
    end

    assert_redirected_to recruit_infos_url
  end
end
