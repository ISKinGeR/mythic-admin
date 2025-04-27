export default (type) => {
	switch (type) {
	  case "Developer":
		return developer;
	  case "Owner":
		return owner;
	  case "Admin":
		return admin;
	  case "Staff":
		return staff;
	  case "Mod":
		return mod;
	  default:
		return support;
	}
  };
  
  const support = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		label: 'Dashboard',
		path: '/',
		exact: true,
	},
	{
		name: 'players',
		icon: ['fas', 'user-large'],
		label: 'Players',
		path: '/players',
		exact: true,
	},
	{
		name: 'disconnected-players',
		icon: ['fas', 'user-large-slash'],
		label: 'Disconnected Players',
		path: '/disconnected-players',
		exact: true,
	},
	{
		name: 'commands',
		icon: ['fas', 'fa-terminal'],
		label: 'commands list',
		path: '/commands',
		exact: true,
	}
];
const mod = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		label: 'Dashboard',
		path: '/',
		exact: true,
	},
	{
		name: 'players',
		icon: ['fas', 'user-large'],
		label: 'Players',
		path: '/players',
		exact: true,
	},
	{
		name: 'disconnected-players',
		icon: ['fas', 'user-large-slash'],
		label: 'Disconnected Players',
		path: '/disconnected-players',
		exact: true,
	},
	{
		name: 'commands',
		icon: ['fas', 'fa-terminal'],
		label: 'commands list',
		path: '/commands',
		exact: true,
	}
];
const staff = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		label: 'Dashboard',
		path: '/',
		exact: true,
	},
	{
		name: 'players',
		icon: ['fas', 'user-large'],
		label: 'Players',
		path: '/players',
		exact: true,
	},
	{
		name: 'disconnected-players',
		icon: ['fas', 'user-large-slash'],
		label: 'Disconnected Players',
		path: '/disconnected-players',
		exact: true,
	},
	{
		name: 'commands',
		icon: ['fas', 'fa-terminal'],
		label: 'commands list',
		path: '/commands',
		exact: true,
	}
];

const admin = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		label: 'Dashboard',
		path: '/',
		exact: true,
	},
    {
		name: 'players',
		icon: ['fas', 'user-large'],
		label: 'Players',
		path: '/players',
		exact: true,
	},
	{
		name: 'disconnected-players',
		icon: ['fas', 'user-large-slash'],
		label: 'Disconnected Players',
		path: '/disconnected-players',
		exact: true,
	},
	{
		name: 'commands',
		icon: ['fas', 'fa-terminal'],
		label: 'commands list',
		path: '/commands',
		exact: true,
	},
	{
		name: 'current-vehicle',
		icon: ['fas', 'car-side'],
		label: 'Current Vehicle',
		path: '/current-vehicle',
		exact:  true,
	},
	{
		name: 'AdminList',
		icon: ['fas', 'fa-users'],
		label: 'AdminList',
		path: '/AdminList',
		exact: true,
	},
	{
		name: 'Devtools',
		icon: ['fas', 'code'],
		label: 'Dev Tools',
		path: '/Devtools',
		exact:  true,
	}
];

const owner = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		label: 'Dashboard',
		path: '/',
		exact: true,
	},
    {
		name: 'players',
		icon: ['fas', 'user-large'],
		label: 'Players',
		path: '/players',
		exact: true,
	},
	{
		name: 'disconnected-players',
		icon: ['fas', 'user-large-slash'],
		label: 'Disconnected Players',
		path: '/disconnected-players',
		exact: true,
	},
	{
		name: 'commands',
		icon: ['fas', 'fa-terminal'],
		label: 'commands list',
		path: '/commands',
		exact: true,
	},
	{
		name: 'AdminList',
		icon: ['fas', 'fa-users'],
		label: 'AdminList',
		path: '/AdminList',
		exact: true,
	},
	{
		name: 'current-vehicle',
		icon: ['fas', 'car-side'],
		label: 'Current Vehicle',
		path: '/current-vehicle',
		exact:  true,
	},
	{
		name: 'Devtools',
		icon: ['fas', 'code'],
		label: 'Dev Tools',
		path: '/Devtools',
		exact:  true,
	}
];

const developer = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		label: 'Dashboard',
		path: '/',
		exact: true,
	},
    {
		name: 'players',
		icon: ['fas', 'user-large'],
		label: 'Players',
		path: '/players',
		exact: true,
	},
	{
		name: 'disconnected-players',
		icon: ['fas', 'user-large-slash'],
		label: 'Disconnected Players',
		path: '/disconnected-players',
		exact: true,
	},
	{
		name: 'commands',
		icon: ['fas', 'fa-terminal'],
		label: 'commands list',
		path: '/commands',
		exact: true,
	},
	{
		name: 'AdminList',
		icon: ['fas', 'fa-users'],
		label: 'AdminList',
		path: '/AdminList',
		exact: true,
	},
	{
		name: 'current-vehicle',
		icon: ['fas', 'car-side'],
		label: 'Current Vehicle',
		path: '/current-vehicle',
		exact:  true,
	},
	{
		name: 'Devtools',
		icon: ['fas', 'code'],
		label: 'Dev Tools',
		path: '/Devtools',
		exact:  true,
	}
];