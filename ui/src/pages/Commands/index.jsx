import React, { useState, useEffect, useCallback } from 'react';
import { 
    TextField, Dialog, DialogTitle, DialogContent, DialogActions,
    Button, IconButton, InputAdornment, List, ListItem, ListItemText,
    Autocomplete, FormControlLabel, Switch, FormControl,
    CircularProgress, MenuItem, Select, InputLabel, Box, Tooltip,
    Checkbox, FormGroup, FormHelperText 
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import commandCategories from './commandList';
import Nui from '../../util/Nui';
import { toast } from 'react-toastify';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        padding: '20px',
        height: '100%',
        display: 'flex',
        flexDirection: 'column',
    },
    searchField: {
        flex: 1,
        marginBottom: 0,
        minWidth: '250px',
    },
    categoryHeader: {
        backgroundColor: 'rgba(0, 0, 0, 0.04)',
        padding: '10px 15px',
        borderRadius: '4px',
        marginBottom: '10px',
        cursor: 'pointer',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
    },
    categoryTitle: {
        fontWeight: 600,
        fontSize: '1.1rem',
    },
    commandList: {
        marginBottom: '20px',
    },
    commandItem: {
        border: '1px solid rgba(0, 0, 0, 0.12)',
        borderRadius: '4px',
        marginBottom: '8px',
        display: 'flex',
        alignItems: 'center',
    },
    toggleIcon: {
        color: '#4caf50',
        marginRight: '12px',
    },
    starIcon: {
        color: '#FFD700',
        cursor: 'pointer',
        marginLeft: '8px',
        fontSize: '20px',
    },
    starIconEmpty: {
        color: 'rgba(0, 0, 0, 0.54)',
        cursor: 'pointer',
        marginLeft: '8px',
        fontSize: '20px',
    },
    scrollContainer: {
        flex: 1,
        overflowY: 'auto',
    },
    paramField: {
        marginTop: '16px',
        position: 'relative',
    },
    suggestionList: {
        maxHeight: '200px',
        overflowY: 'auto',
        position: 'absolute',
        width: '100%',
        zIndex: 1000,
        backgroundColor: '#fff',
        boxShadow: '0 2px 4px rgba(0,0,0,0.2)',
        top: '100%',
        left: 0,
    },
    suggestionItem: {
        padding: '8px 16px',
        cursor: 'pointer',
        '&:hover': {
            backgroundColor: 'rgba(0, 0, 0, 0.04)',
        },
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    itemLabel: {
        color: 'rgba(0, 0, 0, 0.6)',
        marginLeft: '8px',
    },
    itemInfo: {
        display: 'flex',
        flexDirection: 'column',
    },
    itemName: {
        fontWeight: 500,
    },
    itemDetails: {
        fontSize: '0.8rem',
        color: 'rgba(0, 0, 0, 0.6)',
    },
    error: {
        color: '#f44336',
        marginTop: '8px',
    },
    dialogContent: {
        paddingTop: '8px',
    },
    loadingOverlay: {
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        zIndex: 9999,
    },
    unloadedChoicesWarning: {
        color: 'red',
        marginTop: '10px',
    },
    activeFilter: {
        backgroundColor: theme.palette.primary.main,
        color: theme.palette.primary.contrastText,
    },
    filterContainer: {
        display: 'flex',
        alignItems: 'center',
        marginBottom: '20px',
        gap: '16px',
    },
    filterSelect: {
        minWidth: '140px',
    },
    toggleButton: {
        marginLeft: theme.spacing(1),
        backgroundColor: theme.palette.background.paper,
        color: theme.palette.text.primary,
        whiteSpace: 'nowrap',
        overflow: 'hidden',
        textOverflow: 'ellipsis',
        minWidth: 'fit-content',
        padding: '6px 12px',
        fontSize: '0.85rem',
        transition: 'font-size 0.2s ease',
        '&.active': {
            backgroundColor: theme.palette.primary.main,
            color: theme.palette.primary.contrastText,
        },
        '& .MuiButton-startIcon': {
            '& svg': {
                fontSize: '0.85rem',
            }
        }
    },
    buttonContainer: {
        display: 'flex',
        maxWidth: '100%',
    },
    filterContainer: {
        display: 'flex',
        alignItems: 'center',
        marginBottom: theme.spacing(2),
        gap: theme.spacing(1),
    },
    searchAndFilterContainer: {
        marginBottom: theme.spacing(2),
    },
    searchRow: {
        display: 'flex',
        alignItems: 'center',
        gap: theme.spacing(2),
    },
    filterButtons: {
        display: 'flex',
        alignItems: 'center',
    },
}));


const Commands = () => {
    const classes = useStyles();
    const [searchQuery, setSearchQuery] = useState('');
    const [selectedCommand, setSelectedCommand] = useState(null);
    const [dialogOpen, setDialogOpen] = useState(false);
    const [paramValues, setParamValues] = useState({});
    const [error, setError] = useState('');
    const [toggleStates, setToggleStates] = useState({});
    const [favorites, setFavorites] = useState(() => {
        const saved = localStorage.getItem('commandFavorites');
        return saved ? JSON.parse(saved) : [];
    });
    const [showOnlyFavorites, setShowOnlyFavorites] = useState(false);
    const [commandChoices, setCommandChoices] = useState({});
    const [players, setPlayers] = useState([]);
    const [playerPermission, setPlayerPermission] = useState('');
    const [loadingChoices, setLoadingChoices] = useState({});
    const [unloadedChoices, setUnloadedChoices] = useState({});
    const [autoCloseDialog, setAutoCloseDialog] = useState(false);
    const [activeFilter, setActiveFilter] = useState('ALL');
    const allTags = ['ALL'];
    const allCommands = [];
    const [keepTarget, setKeepTarget] = useState(false);
    const [lastTarget, setLastTarget] = useState(null);


    Object.values(commandCategories).forEach(category => {
        category.commands.forEach(command => {
            const categoryTag = category.label.toUpperCase();
            if (!allTags.includes(categoryTag)) {
                allTags.push(categoryTag);
            }
            
            (command.tags || []).forEach(tag => {
                const upperTag = tag.toUpperCase();
                if (!allTags.includes(upperTag)) {
                    allTags.push(upperTag);
                }
            });
            
            allCommands.push({
                ...command,
                tags: [categoryTag, ...(command.tags || []).map(t => t.toUpperCase())]
            });
        });
    });

    allTags.sort((a, b) => {
        if (a === 'ALL') return -1;
        if (b === 'ALL') return 1;
        return a.localeCompare(b);
    });

    const hasPermission = (command) => {
        if (!command.roles || command.roles.length === 0) return false;
        return command.roles.includes(playerPermission);
    };

    const fetchPlayers = async () => {
        try {
            const response = await Nui.send("GetPlayerList", { disconnected: false });
            const data = await response.json();
            setPlayers(data);
            return data;
        } catch (error) {
            return [];
        }
    };

    const fetchPlayerPermission = async () => {
        try {
            const response = await Nui.send("GetPlayerPermission", {});
            const permission = await response.json();
            setPlayerPermission(permission);
        } catch (error) {
        }
    };

    const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

    const fetchChoicesWithRetry = useCallback(async (cacheKey, retries = 2) => {
        const [action, , param] = cacheKey.split(':');
        setLoadingChoices(prev => ({
            ...prev,
            [action]: { ...prev[action], [param]: true }
        }));

        for (let i = 0; i <= retries; i++) {
            try {
                const response = await Nui.send(cacheKey);
                const choices = await response.json();
                
                setLoadingChoices(prev => ({
                    ...prev,
                    [action]: { ...prev[action], [param]: false }
                }));

                return choices.map(choice => {
                    if (typeof choice === 'string') {
                        const match = choice.match(/^(.+?)(?: $$(.+)$$)?$/);
                        if (match) {
                            return {
                                value: match[1],
                                label: choice
                            };
                        }
                        return { value: choice, label: choice };
                    }
                    if (choice.name) {
                        const match = choice.name.match(/^(.+?)(?: $$(.+)$$)?$/);
                        if (match) {
                            return {
                                value: match[1],
                                label: choice.label || choice.name
                            };
                        }
                    }
                    return {
                        value: choice.name || choice,
                        label: choice.label || choice.name || choice
                    };
                }).sort((a, b) => a.label.localeCompare(b.label));
            } catch (error) {
                console.error(`Error loading choices for ${cacheKey}, attempt ${i + 1}:`, error);
                if (i === retries) {
                    setLoadingChoices(prev => ({
                        ...prev,
                        [action]: { ...prev[action], [param]: false }
                    }));
                    return null;
                }
                await delay(1000);
            }
        }
    }, []);

    const loadChoices = useCallback(async (playerData) => {
        const newCommandChoices = {};
        const newUnloadedChoices = {};
        const choiceCache = {};

        for (const category in commandCategories) {
            const commands = commandCategories[category].commands;
            for (const command of commands) {
                newCommandChoices[command.action] = {};
                for (const param of command.params || []) {
                    if (param.parmasType === 'choices' && param.name === 'player') {
                        const playerChoices = playerData.map(player => ({
                            value: player.Source,
                            label: `${player.Character ? `${player.Character.First ?? ''} ${player.Character.Last ?? ''}`.trim() : 'Unknown Character'} (${player.Name} - ${player.Identifier})`
                        })).sort((a, b) => a.label.localeCompare(b.label));
                        newCommandChoices[command.action][param.name] = playerChoices;
                    }
                }
            }
        }

        for (const category in commandCategories) {
            const commands = commandCategories[category].commands;
            for (const command of commands) {
                for (const param of command.params || []) {
                    if (param.parmasType === 'choices' && param.name !== 'player') {
                        if (choiceCache[param.name]) {
                            newCommandChoices[command.action][param.name] = choiceCache[param.name];
                        } else {
                            const cacheKey = `${command.action}:choices:${param.name}`;
                            const choices = await fetchChoicesWithRetry(cacheKey);
                            if (choices) {
                                newCommandChoices[command.action][param.name] = choices;
                                choiceCache[param.name] = choices;
                            } else {
                                if (!newUnloadedChoices[command.action]) {
                                    newUnloadedChoices[command.action] = [];
                                }
                                newUnloadedChoices[command.action].push(param.name);
                            }
                        }
                        await delay(100);
                    }
                }
            }
        }

        setCommandChoices(newCommandChoices);
        setUnloadedChoices(newUnloadedChoices);
        toast.success('Finish loading choices!');
    }, [fetchChoicesWithRetry]);

    useEffect(() => {
        const initializeComponent = async () => {
            const initialExpanded = {};
            Object.keys(commandCategories).forEach(category => {
                initialExpanded[category] = false;
            });
            
            const playerData = await fetchPlayers();
            await fetchPlayerPermission();
            await loadChoices(playerData);
        };

        initializeComponent();
    }, [loadChoices]);

    useEffect(() => {
        localStorage.setItem('commandFavorites', JSON.stringify(favorites));
    }, [favorites]);


    const handleCommandClick = (command) => {
        if (unloadedChoices[command.action] && unloadedChoices[command.action].length > 0) {
            setError(`Cannot execute command. Choices for ${unloadedChoices[command.action].join(', ')} failed to load.`);
            return;
        }

        if (command.params.length === 0) {
            handleExecuteCommand(command);
        } else {
            setSelectedCommand(command);
            setParamValues({});
            setError('');
            setDialogOpen(true);
        }
    };

    const handleExecuteCommand = async (command) => {
        try {
            const paramObject = selectedCommand.params.reduce((obj, param) => {
                if (keepTarget && lastTarget && param.name === 'target') {
                    obj[param.name] = lastTarget;
                } else {
                    obj[param.name] = paramValues[param.name];
                }
                return obj;
            }, {});

            if (paramObject.target) {
                setLastTarget(paramObject.target);
            }

            await Nui.send(command.action, paramObject);
            await Nui.send('AdminLogSaver', { command: command.action, params: paramObject });

            if (!autoCloseDialog) {
                if (!keepTarget) {
                    setParamValues(prev => {
                        const newValues = { ...prev };
                        if (newValues.target) delete newValues.target;
                        return newValues;
                    });
                }
            } else {
                handleDialogClose();
            }
        } catch (err) {
            setError('Failed to execute command');
            console.error(err);
        }
    };

    const renderFilterBar = () => {
        const buttonLabels = [
            { id: 'favorites', label: 'Favorites', label2: 'Show Only Favorites Commands', icon: 'star', active: showOnlyFavorites, action: () => setShowOnlyFavorites(!showOnlyFavorites) },
            { id: 'autoclose', label: 'Auto Close', label2: 'Auto Close after Exectue', icon: 'window-close', active: autoCloseDialog, action: () => setAutoCloseDialog(!autoCloseDialog) },
            // { id: 'keeptarget', label: 'Keep Target', icon: 'lock', active: keepTarget, action: () => setKeepTarget(!keepTarget) },
        ];
    
        return (
            <Box className={classes.filterContainer}>
                <TextField className={classes.searchField}
                        variant="outlined"
                        placeholder="Search commands..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        InputProps={{
                            startAdornment: (
                                <InputAdornment position="start">
                                    <FontAwesomeIcon icon={['fas', 'search']} />
                                </InputAdornment>
                            ),
                            endAdornment: searchQuery && (
                                <InputAdornment position="end">
                                    <IconButton size="small" onClick={() => setSearchQuery('')}>
                                        <FontAwesomeIcon icon={['fas', 'xmark']} />
                                    </IconButton>
                                </InputAdornment>
                            ),
                        }}
                    />
                <FormControl variant="outlined" className={classes.filterSelect}>
                    <Autocomplete
                        options={allTags}
                        value={activeFilter}
                        onChange={(e, newValue) => setActiveFilter(newValue || 'ALL')}
                        renderInput={(params) => (
                            <TextField 
                                {...params} 
                                label="Filter by Type" 
                                variant="outlined" 
                            />
                        )}
                    />
                </FormControl>
    
                {buttonLabels.map((btn) => (
                    <Tooltip key={btn.id} title={btn.label2}>
                        <div className={classes.buttonContainer}>
                            <Button
                                variant="contained"
                                className={`${classes.toggleButton} ${btn.active ? 'active' : ''}`}
                                onClick={btn.action}
                                startIcon={<FontAwesomeIcon icon={['fas', btn.icon]} />}
                            >
                                {btn.label}
                            </Button>
                        </div>
                    </Tooltip>
                ))}
            </Box>
        );
    };

    const handleDialogClose = () => {
        setDialogOpen(false);
        setSelectedCommand(null);
        setParamValues({});
        setError('');
    };

    const renderDialogContent = () => (
        <DialogContent className={classes.dialogContent}>
            {selectedCommand?.params.map((param) => renderParamField(param))}
            {error && <p className={classes.error}>{error}</p>}
        </DialogContent>
    );

    const handleToggleFavorite = (command, event) => {
        event.stopPropagation();
        setFavorites(prev => {
            const commandId = `${command.category}_${command.action}`;
            if (prev.includes(commandId)) {
                return prev.filter(id => id !== commandId);
            }
            return [...prev, commandId];
        });
    };

    const isCommandFavorite = (command) => {
        return favorites.includes(`${command.category}_${command.action}`);
    };

    const renderParamField = (param) => {
        if (param.parmasType === 'choices') {
            const choices = commandChoices[selectedCommand.action]?.[param.name] || [];
            
            return (
                <FormControl fullWidth className={classes.paramField} key={param.name}>
                    <Autocomplete
                        options={choices}
                        getOptionLabel={(option) => option.label}
                        value={choices.find(choice => choice.value === paramValues[param.name] || choice.label === paramValues[param.name]) || null}
                        onChange={(event, newValue) => {
                            setParamValues(prev => ({
                                ...prev,
                                [param.name]: newValue ? newValue.value : '',
                            }));
                        }}
                        renderInput={(params) => (
                            <TextField {...params} label={param.help} variant="outlined" />
                        )}
                    />
                </FormControl>
            );
        }

        return (
            <TextField
                key={param.name}
                label={param.help}
                value={paramValues[param.name] || ''}
                onChange={(e) => setParamValues(prev => ({
                    ...prev,
                    [param.name]: e.target.value,
                }))}
                variant="outlined"
                fullWidth
                className={classes.paramField}
            />
        );
    };

    const filterCommands = (commands) => {
        return commands.filter(command => {
            const matchesFilter = activeFilter === 'ALL' || command.tags.includes(activeFilter);
            
            const matchesSearch = command.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                command.description.toLowerCase().includes(searchQuery.toLowerCase());
            
            const hasRequiredPermission = hasPermission(command);
            
            if (showOnlyFavorites) {
                return matchesFilter && matchesSearch && isCommandFavorite(command) && hasRequiredPermission;
            }
            return matchesFilter && matchesSearch && hasRequiredPermission;
        });
    };


    return (
        <div className={classes.wrapper}>
            <div>
                    {renderFilterBar()}
            </div>

            <div className={classes.scrollContainer}>
                <List className={classes.commandList}>
                    {filterCommands(allCommands).map((command) => (
                        <ListItem 
                            button 
                            key={command.action}
                            onClick={() => handleCommandClick(command)}
                            className={classes.commandItem}
                            disabled={
                                (unloadedChoices[command.action] && unloadedChoices[command.action].length > 0) ||
                                (loadingChoices[command.action] && Object.values(loadingChoices[command.action]).some(loading => loading))
                            }
                            style={{
                                opacity: (unloadedChoices[command.action] && unloadedChoices[command.action].length > 0) ||
                                        (loadingChoices[command.action] && Object.values(loadingChoices[command.action]).some(loading => loading))
                                    ? 0.5
                                    : 1
                            }}
                        >
                            <ListItemText
                                primary={command.name}
                                secondary={
                                    <>
                                        {command.description}
                                        {loadingChoices[command.action] && 
                                         Object.values(loadingChoices[command.action]).some(loading => loading) && (
                                            <div style={{ color: 'orange', marginTop: '4px' }}>
                                                Loading choices...
                                            </div>
                                        )}
                                        {unloadedChoices[command.action] && unloadedChoices[command.action].length > 0 && (
                                            <div className={classes.unloadedChoicesWarning}>
                                                Unloaded choices: {unloadedChoices[command.action].join(', ')}
                                            </div>
                                        )}
                                    </>
                                }
                            />
                            <div style={{ display: 'flex', alignItems: 'center' }}>
                                {command.isToggle && toggleStates[command.action] && (
                                    <FontAwesomeIcon 
                                        icon={['fas', 'circle-check']} 
                                        className={classes.toggleIcon}
                                    />
                                )}
                                <FontAwesomeIcon
                                    icon={['fas', 'star']}
                                    className={isCommandFavorite(command) ? classes.starIcon : classes.starIconEmpty}
                                    onClick={(e) => handleToggleFavorite(command, e)}
                                />
                            </div>
                        </ListItem>
                    ))}
                </List>
            </div>

            {/* Keep the dialog part the same */}
            <Dialog 
                open={dialogOpen} 
                onClose={handleDialogClose}
                maxWidth="sm"
                fullWidth
            >
                <DialogTitle>{selectedCommand?.name}</DialogTitle>
                {renderDialogContent()}
                <DialogActions>
                    <Button onClick={handleDialogClose} color="primary">
                        Cancel
                    </Button>
                    <Button 
                        onClick={() => handleExecuteCommand(selectedCommand)} 
                        color="primary" 
                        variant="contained"
                    >
                        Execute
                    </Button>
                </DialogActions>
            </Dialog>
        </div>
    );
};

export default Commands;