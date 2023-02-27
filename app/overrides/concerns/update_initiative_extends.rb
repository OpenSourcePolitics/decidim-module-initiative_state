# frozen_string_literal: true

module UpdateInitiativeExtends
  private

  def attributes
    attrs = {
      title: form.title,
      description: form.description,
      hashtag: form.hashtag,
      decidim_status_id: form.status_id
    }

    if form.signature_type_updatable?
      attrs[:signature_type] = form.signature_type
      attrs[:scoped_type_id] = form.scoped_type_id if form.scoped_type_id
    end

    if current_user.admin?
      add_admin_accessible_attrs(attrs)
    elsif initiative.created?
      attrs[:signature_end_date] = form.signature_end_date if initiative.custom_signature_end_date_enabled?
      attrs[:decidim_area_id] = form.area_id if initiative.area_enabled?
    end

    attrs
  end
end
