$document_root = '/vagrant'

include apache

exec { 'Skip Message':
	command => "echo 'Este mensaje solo se muestra si no se ha copiado el fichero index.html'",
	unless => "test -f ${document_root}/index.html",
	# Atributo unless: sirve para condicionar la ejecución
	path => "/bin:/sbin:/usr/bin:/usr/sbin",
}

notify { 'Showing machine Facts': # Este fichero se ejecuto solamente si no se cumple el fichero "exec"
	message => "Machine with ${::memory['system']['total']} of memory and $::processorcount processor/s. Please check access to http://$::ipaddress_enp0s8}",
# Atributo Message: muestra valores facts como memoria de la VM, numero de procesadores y dirección ip
}
