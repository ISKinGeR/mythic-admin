import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
    TableContainer,
    Table,
    TableHead,
    TableRow,
    TableCell,
    TableBody,
    Paper,
    TextField,
    InputAdornment,
    IconButton,
    Pagination,
    MenuItem,
    Avatar,
    Grid,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Nui from '../../util/Nui';
import { Loader } from '../../components';
import { useHistory } from 'react-router';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        padding: '20px',
        height: '100%',
    },
    search: {
        marginBottom: theme.spacing(2),
    },
    tableContainer: {
        boxShadow: 'none',
        backgroundColor: 'transparent',
        maxHeight: 'calc(100% - 120px)',
        overflow: 'auto',
    },
    tableRow: {
        '&:hover': {
            backgroundColor: theme.palette.action.hover,
            cursor: 'pointer',
        },
    },
    avatarCell: {
        display: 'flex',
        alignItems: 'center',
    },
    avatar: {
        marginRight: theme.spacing(2),
        width: theme.spacing(4),
        height: theme.spacing(4),
    },
    pagination: {
        marginTop: theme.spacing(2),
        display: 'flex',
        justifyContent: 'center',
    },
    characterName: {
        color: theme.palette.text.secondary,
    },
}));

const PlayerList = (props) => {
    const classes = useStyles();
    const history = useHistory();
    const dispatch = useDispatch();
    const PER_PAGE = 15;

    const [searched, setSearched] = useState('');
    const [includeLoggedOut, setIncludeLoggedOut] = useState(false);
    const [pages, setPages] = useState(1);
    const [page, setPage] = useState(1);
    const [loading, setLoading] = useState(false);
    const [results, setResults] = useState([]);
    const [players, setPlayers] = useState([]);

    useEffect(() => {
        fetch();
        const interval = setInterval(() => fetch(), 60 * 1000);
        return () => clearInterval(interval);
    }, []);

    useEffect(() => {
        setPages(Math.ceil(players.length / PER_PAGE));
    }, [players]);

    useEffect(() => {
        const filteredPlayers = results.filter((r) => {
            const nameMatches = r.Name && r.Name.toLowerCase().includes(searched.toLowerCase());
            const accountIdMatches = r.AccountID == parseInt(searched);
            const characterNameMatches =
                r.Character &&
                `${r.Character.First ?? ''} ${r.Character.Last ?? ''}`
                    .toLowerCase()
                    .includes(searched.toLowerCase());
            const characterSidMatches = r.Character && r.Character.SID == parseInt(searched);
    
            return (
                (nameMatches || accountIdMatches || characterNameMatches || characterSidMatches) &&
                (r.Character || !includeLoggedOut)
            );
        });
        setPlayers(filteredPlayers);
    }, [results, searched, includeLoggedOut]);

    const fetch = async () => {
        setLoading(true);
        try {
            let res = await(await Nui.send('GetPlayerList', {
                disconnected: false,
            })).json();
            if (res) setResults(res);
        } catch(e) {
            setResults([
                {
                    AccountID: 1,
                    Source: 1,
                    Name: 'Dr Nick',
                    Character: {
                        First: 'Walter',
                        Last: 'Western',
                        SID: 3
                    }
                },
                {
                    AccountID: 2,
                    Source: 2,
                    Name: 'Panda',
                    // Character: {
                    //     First: 'Willy',
                    //     Last: 'Western',
                    //     SID: 4
                    // }
                },
            ]);
        }
        setLoading(false);
    };

    const onClear = () => setSearched('');
    const onPagi = (e, p) => setPage(p);

    const handlePlayerClick = (player) => {
        history.push(`/player/${player.Source}`);
    };

    return (
        <div className={classes.wrapper}>
            <Grid container spacing={2} className={classes.search}>
                <Grid item xs={12} sm={4}>
                    <TextField
                        select
                        fullWidth
                        label="Filter"
                        value={includeLoggedOut}
                        onChange={(e) => setIncludeLoggedOut(e.target.value)}
                    >
                        <MenuItem value={false}>Show All</MenuItem>
                        <MenuItem value={true}>Logged In</MenuItem>
                    </TextField>
                </Grid>
                <Grid item xs={12} sm={8}>
                    <TextField
                        fullWidth
                        variant="outlined"
                        name="search"
                        value={searched}
                        onChange={(e) => setSearched(e.target.value)}
                        label="Search"
                        InputProps={{
                            endAdornment: (
                                <InputAdornment position="end">
                                    {searched != '' && (
                                        <IconButton type="button" onClick={onClear}>
                                            <FontAwesomeIcon icon={['fas', 'xmark']} />
                                        </IconButton>
                                    )}
                                </InputAdornment>
                            ),
                        }}
                    />
                </Grid>
            </Grid>

            {loading ? (
                <Loader text="Loading" />
            ) : (
                <>
                    <TableContainer component={Paper} className={classes.tableContainer}>
                        <Table stickyHeader aria-label="player table">
                            <TableHead>
                                <TableRow>
                                    <TableCell>Account ID</TableCell>
                                    <TableCell>Player</TableCell>
                                    <TableCell>Character</TableCell>
                                    <TableCell>Source</TableCell>
                                </TableRow>
                            </TableHead>
                            <TableBody>
                                {players
                                    .slice((page - 1) * PER_PAGE, page * PER_PAGE)
                                    .sort((a, b) => b.Source - a.Source)
                                    .map((player) => (
                                        <TableRow 
                                            key={player.Source} 
                                            className={classes.tableRow}
                                            onClick={() => handlePlayerClick(player)}
                                        >
                                            <TableCell>{player.AccountID}</TableCell>
                                            <TableCell>
                                                <div className={classes.avatarCell}>
                                                    <Avatar className={classes.avatar}>
                                                        {player.Name?.charAt(0)}
                                                    </Avatar>
                                                    {player.Name}
                                                </div>
                                            </TableCell>
                                            <TableCell>
                                                {player.Character ? (
                                                    <>
                                                        {player.Character.First} {player.Character.Last}
                                                        <div className={classes.characterName}>
                                                            SID: {player.Character.SID}
                                                        </div>
                                                    </>
                                                ) : (
                                                    'Not Logged In'
                                                )}
                                            </TableCell>
                                            <TableCell>{player.Source}</TableCell>
                                        </TableRow>
                                    ))}
                            </TableBody>
                        </Table>
                    </TableContainer>

                    {pages > 1 && (
                        <div className={classes.pagination}>
                            <Pagination
                                variant="outlined"
                                shape="rounded"
                                color="primary"
                                page={page}
                                count={pages}
                                onChange={onPagi}
                            />
                        </div>
                    )}
                </>
            )}
        </div>
    );
};

export default PlayerList;