class AnimalsController < ApplicationController
  def index
    vet_clinic_accessor = AccessToken.new 
    vet_clinic_accessor.get_access_token
    @animals = vet_clinic_accessor.get_animals
    @test = "hellooo"
  end
end
