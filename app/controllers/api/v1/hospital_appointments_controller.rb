class Api::V1::HospitalAppointmentsController < Api::V1::BaseController
  before_action :set_hospital_appointment, only: [:show, :update, :destroy]

  def index
    @hospital_appointments = current_user.hospital_appointments.in_target_month(get_hospital_appointment_params[:target_month])
    render json: @hospital_appointments, each_serializer: HospitalAppointmentSerializer
  end

  def show
    render json: @hospital_appointment, serializer: HospitalAppointmentSerializer
  end

  def create
    @hospital_appointment = current_user.hospital_appointments.build(hospital_appointment_params)
    @hospital_appointment.save
    render json: @hospital_appointment, serializer: HospitalAppointmentSerializer
  end

  def update
    @hospital_appointment.update(hospital_appointment_params)
  end

  def destroy
    @hospital_appointment.destroy
  end

  private

  def get_hospital_appointment_params
    params.permit(:target_month)
  end

  def hospital_appointment_params
    params.require(:hospital_appointment).permit(:consultation_date, :memo)
  end

  def set_hospital_appointment
    @hospital_appointment = current_user.hospital_appointments.find(params[:id])
  end
end
