class apache { # Se crea la clase/modulo apache
	exec { 'apt-update':
	# Nos permite ejecutar un comando directamente en la VM
		command => '/usr/bin/apt-get update'
	# Actualiza la cache del gestor de paquetes apt antes de instalar apache2
	}
	
	exec["apt-update"] -> Package <| |> 
# Relacion de dependencia indica que todo recurso tipo 'package' debe ejecutar apt-update
	package { 'apache2': 
		ensure => intalled,
	}
	
	file { '/etc/apache2/site-enabled/000-default.conf':
	# Inicia Fichero 1: Encargado de borrar la configuracion por default
		ensure => abstent,
	# Se asegura de que la configuracion sea ausente de lo contrario lo borra
		require => Package['apache2'], 
	# Evalúa el paquete apache2
	} # Fin fichero 1
		
	file { '/etc/apache2/sites-available/vagrant.conf':
	# Inicia Fichero 2:  Crear nueva configuracion
		content => template('apache/virtual-hosts.conf.erb',
	# Nuevo contenido con la plantilla sobre el fichero "template" en formato ".erb"
		require => File['/etc/apache2/sites-enabled/000-defaul.conf'],
	# 
	} # Fin Fichero 2
	
	file { "/etc/apache2/sites-enabled/vagrant.conf":
	# Inica Fichero 3: Enlace simbolico en directorio sites-enabled
		ensure => link,
	# Asignacion a un enlace simbolico
		target => "/etc/apache2/sites-available/vagrant.conf",
	# Marca el directorio posicionado
		require => File['/etc/apache2/sites-available/vagrant.conf'],
	# Requerimiento de la asignacion
		notify => Service['apache2'],
	# atributo notify - Lanza una notificacion de algun cambio
	} # Fin Fichero 3
	
	file { "${document_root}/index.html":
	# Inicio Fichero 4: Referir a la pagina HTML (index.html)
		ensure => present,
	# Asignacion de la pagina html
		source => "/etc/apache2/sites-available/vagrant.conf",
	# Fuente posicionada en /vagrant.conf (directorio raiz) de nuestro sitio web
		require => File['/etc/apache2/sites-enabled/vagrant.conf'],
	# Requerimiento de la asignacion
		notify => Service['apache2'],
	# atributo notify - Lanza una notificacion de algun cambio
	} # Fin Fichero 4
	
	service { 'apache2':
		ensure => running,
		enable => true,
		hasstatus => true,
		restart => "/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload",
	}
}

