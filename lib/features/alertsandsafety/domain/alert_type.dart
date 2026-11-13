enum AlertType {
  emergency,
  inactivity;

  static AlertType fromName(String name) {
    return name == 'INACTIVITY' ? AlertType.inactivity : AlertType.emergency;
  }
}
