import React, { useEffect, useState } from 'react';
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
import { Loader } from '../../components';
import Nui from '../../util/Nui';
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
}));

const AdminList = () => {
    const classes = useStyles();
    const history = useHistory();
    const PER_PAGE = 15;

    const [searched, setSearched] = useState('');
    const [includeLoggedOut, setIncludeLoggedOut] = useState(false);
    const [pages, setPages] = useState(1);
    const [page, setPage] = useState(1);
    const [loading, setLoading] = useState(false);
    const [results, setResults] = useState([]);
    const [admins, setAdmins] = useState([]);

    useEffect(() => {
        fetchAdmins();
        const interval = setInterval(() => fetchAdmins(), 60000);
        return () => clearInterval(interval);
    }, []);

    useEffect(() => {
        setPages(Math.ceil(admins.length / PER_PAGE));
    }, [admins]);

    useEffect(() => {
        const filteredAdmins = results.filter((admin) => {
            const nameMatches = admin.Name?.toLowerCase().includes(searched.toLowerCase());
            const sourceMatches = admin.Source?.toString().includes(searched);
            const statusMatches = includeLoggedOut || admin.Status === 'Online';
            return (nameMatches || sourceMatches) && statusMatches;
        });
        setAdmins(filteredAdmins);
    }, [results, searched, includeLoggedOut]);

    const fetchAdmins = async () => {
        setLoading(true);
        try {
            const response = await Nui.send('GetOnlineAdminList');
            const data = await response.json();
            if (Array.isArray(data)) {
                setResults(data);
            } else {
                setResults([]);
            }
        } catch (error) {
            setResults([]);
        }
        setLoading(false);
    };

    const onClear = () => setSearched('');
    const onPagi = (e, p) => setPage(p);

    const handleAdminClick = (admin) => {
        if (admin.Identifier) {
            history.push(`/admin/${admin.Identifier}`);
        }
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
                        <MenuItem value={false}>Logged In</MenuItem>
                        <MenuItem value={true}>Show All</MenuItem>
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
                                    {searched && (
                                        <IconButton onClick={onClear}>
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
                        <Table stickyHeader aria-label="admin table">
                            <TableHead>
                                <TableRow>
                                    <TableCell>Admin</TableCell>
                                    <TableCell>Source</TableCell>
                                    <TableCell>Identifier</TableCell>
                                    <TableCell>Status</TableCell>
                                    <TableCell>AP</TableCell>
                                </TableRow>
                            </TableHead>
                            <TableBody>
                                {admins
                                    .slice((page - 1) * PER_PAGE, page * PER_PAGE)
                                    .map((admin) => (
                                        <TableRow 
                                            key={admin.Source} 
                                            className={classes.tableRow}
                                            onClick={() => handleAdminClick(admin)}
                                        >
                                            <TableCell>
                                                <div className={classes.avatarCell}>
                                                    <Avatar className={classes.avatar}>
                                                        {admin.Name?.charAt(0)}
                                                    </Avatar>
                                                    {admin.Name}
                                                </div>
                                            </TableCell>
                                            <TableCell>{admin.Source}</TableCell>
                                            <TableCell>{admin.Identifier}</TableCell>
                                            <TableCell>{admin.Status || 'Offline'}</TableCell>
                                            <TableCell>{admin.AP || 'N/A'}</TableCell>
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

export default AdminList;