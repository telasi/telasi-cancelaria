# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  belongs_to :department
  has_many :user_indices
  has_many :indices, through: :user_indices

  attr_accessor :password_confirmation
  validates_confirmation_of :password
  validates_presence_of :name, :first_name, :last_name, :phone

  validate :password_non_blank

  # ავტორიზაციის მეთოდი
  def self.authenticate(name, password)
    user = self.find_by_name(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  # პაროლის მიღება
  def password
    @password
  end

  # პაროლის დაყენება
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def full_name
    first_name + ' ' + last_name
  end

  # უფლებების მართვა
  
  def can_edit_departmens
    self.canc_empl or self.admin
  end

  def can_edit_employees
    self.canc_empl or self.admin
  end

  def can_edit_indices
    self.canc_empl or self.admin
  end

  def can_edit_statuses
    self.canc_empl or self.admin
  end

  def can_edit_letters
    self.canc_empl or self.admin
  end
  
  def can_edit_users
    self.admin
  end

  def can_edit_letter_employee(l)
    return true if self.admin or self.canc_empl
    l.departments.each do |d|
      return true if self.department == d
    end
    false
  end

  private

  # პაროლის შემოწმება
  def password_non_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end

  # პაროლის დაკრიპტვა
  def self.encrypted_password(password, salt)
    string_to_hash = password + "dimitri" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  # ავტომატურად ქმნის მარცვალს
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
end
