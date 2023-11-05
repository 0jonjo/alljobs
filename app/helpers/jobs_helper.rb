# frozen_string_literal: true

module JobsHelper
  def companies
    Company.all.map { |c| [c.name, c.id] }
  end

  def countries
    Country.all.map { |c| [c.acronym, c.id] }
  end

  def levels
    Job.levels.keys.map { |level| [I18n.t("activerecord.attributes.job.levels.keys.#{level}"), level] }
  end

  def statuses
    Job.job_statuses.keys.map { |status| [I18n.t("activerecord.attributes.job.job_statuses.keys.#{status}"), status] }
  end
end
