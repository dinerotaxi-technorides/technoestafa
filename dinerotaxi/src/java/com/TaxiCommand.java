package com;

public class TaxiCommand {

	String nombre = "", patente = "", marca = "", empresa = "",
			numeroMovil = "", modelo = "", companyPhone = "";

	TaxiCommand(String nombre, String patente, String marca, String empresa,
			String numeroMovil) {
		this.nombre = nombre;
		this.patente = patente;
		this.marca = marca;
		this.empresa = empresa;
		this.numeroMovil = numeroMovil;
	}

	TaxiCommand(String nombre, String patente, String marca) {
		this.nombre = nombre;
		this.patente = patente;
		this.marca = marca;
	}

	TaxiCommand() {
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getPatente() {
		return patente;
	}

	public void setPatente(String patente) {
		this.patente = patente;
	}

	public String getMarca() {
		return marca;
	}

	public void setMarca(String marca) {
		this.marca = marca;
	}

	public String getEmpresa() {
		return empresa;
	}

	public void setEmpresa(String empresa) {
		this.empresa = empresa;
	}

	public String getNumeroMovil() {
		return numeroMovil;
	}

	public void setNumeroMovil(String numeroMovil) {
		this.numeroMovil = numeroMovil;
	}

	public String getCompanyPhone() {
		return companyPhone;
	}

	public void setCompanyPhone(String companyPhone) {
		this.companyPhone = companyPhone;
	}

	public String getModelo() {
		return modelo;
	}

	public void setModelo(String modelo) {
		this.modelo = modelo;
	}
}
