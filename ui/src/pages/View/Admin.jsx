import React, { useEffect, useState } from "react"
import {
  List,
  ListItem,
  ListItemText,
  Grid,
  Alert,
  IconButton,
  Collapse,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Box,
} from "@material-ui/core"
import { makeStyles } from "@material-ui/styles"
import { ExpandMore, ExpandLess } from "@material-ui/icons"
import { toast } from "react-toastify"
import moment from "moment"
import Nui from "../../util/Nui"

const useStyles = makeStyles((theme) => ({
  wrapper: {
    padding: "20px 10px 20px 20px",
    height: "100%",
    display: "flex",
    flexDirection: "column",
  },
  header: {
    marginBottom: "20px",
  },
  adminInfoContainer: {
    marginBottom: "30px",
  },
  historyContainer: {
    marginTop: "20px",
    marginBottom: "20px",
  },
  tableContainer: {
    maxHeight: "400px",
    overflowY: "auto",
  },
  tableRow: {
    cursor: "pointer",
    "&:hover": {
      backgroundColor: "rgba(0, 0, 0, 0.04)",
    },
  },
  eventText: {
    fontWeight: "bold",
    fontSize: "1rem",
  },
  dateText: {
    color: "#666666",
    fontSize: "0.875rem",
  },
  expandIcon: {
    transition: "transform 0.3s",
  },
  expandIconRotated: {
    transform: "rotate(180deg)",
  },
  extraInfoContainer: {
    backgroundColor: "rgba(0, 0, 0, 0.02)",
    padding: "16px",
  },
  extraInfoLabel: {
    fontWeight: "bold",
    marginRight: 8,
    color: "#666666",
    display: "inline-block",
    minWidth: "80px",
  },
  extraInfoValue: {
    color: "#666666",
    wordBreak: "break-word",
  },
}))

export default ({ match }) => {
  const classes = useStyles()
  const [loading, setLoading] = useState(false)
  const [admin, setAdmin] = useState(null)
  const [err, setErr] = useState(false)
  const [expandedItem, setExpandedItem] = useState(null)

  const fetchAdminData = async () => {
    setLoading(true)
    try {
      const res = await Nui.send("GetAdminDATA", match)
      const data = await res.json()

      if (data && data.AdminInfo) {
        if (data.AdminInfo.AdminHistory) {
          data.AdminInfo.AdminHistory = data.AdminInfo.AdminHistory.sort((a, b) => {
            const dateA = moment(a.DATE || a.date)
            const dateB = moment(b.DATE || b.date)
            return dateB.valueOf() - dateA.valueOf()
          })
        }
        setAdmin(data)
      } else {
        toast.error("Unable to load admin data")
      }
    } catch (err) {
      console.error("Error fetching admin data:", err)
      toast.error("Error fetching admin data")
      setErr(true)
    }
    setLoading(false)
  }

  useEffect(() => {
    fetchAdminData()
  }, [match])

  const handleHistoryItemClick = (index) => {
    setExpandedItem(expandedItem === index ? null : index)
  }

  const formatDate = (dateStr) => {
    return moment(dateStr).format("LLL")
  }

  const formatExtraInfo = (extraInfo) => {
    if (!extraInfo) return null

    let jsonData = null
    if (typeof extraInfo === "string") {
      try {
        if (extraInfo.startsWith("{") && extraInfo.endsWith("}")) {
          jsonData = JSON.parse(extraInfo)
        }
      } catch (e) {
      }
    } else if (typeof extraInfo === "object") {
      jsonData = extraInfo
    }

    if (jsonData) {
      return (
        <div style={{ width: "100%" }}>
          {Object.entries(jsonData).map(([key, value]) => (
            <div key={key} style={{ marginBottom: "4px" }}>
              <span className={classes.extraInfoLabel}>{key.charAt(0).toUpperCase() + key.slice(1)}:</span>
              <span className={classes.extraInfoValue}>{String(value)}</span>
            </div>
          ))}
        </div>
      )
    }

    if (typeof extraInfo === "string") {
      if (extraInfo.toLowerCase().startsWith("info:")) {
        const parts = extraInfo
          .substring(5)
          .split(",")
          .map((part) => part.trim())

        if (parts.length >= 4 && extraInfo.includes("police")) {
          const [id, job, rank, department] = parts
          return (
            <div style={{ width: "100%" }}>
              <div style={{ marginBottom: "4px" }}>
                <span className={classes.extraInfoLabel}>ID:</span>
                <span className={classes.extraInfoValue}>{id}</span>
              </div>
              <div style={{ marginBottom: "4px" }}>
                <span className={classes.extraInfoLabel}>Job:</span>
                <span className={classes.extraInfoValue}>{job}</span>
              </div>
              <div style={{ marginBottom: "4px" }}>
                <span className={classes.extraInfoLabel}>Rank:</span>
                <span className={classes.extraInfoValue}>{rank}</span>
              </div>
              <div>
                <span className={classes.extraInfoLabel}>Department:</span>
                <span className={classes.extraInfoValue}>{department.toUpperCase()}</span>
              </div>
            </div>
          )
        } else if (parts.length === 2) {
          const [item, amount] = parts
          return (
            <div style={{ width: "100%" }}>
              <div style={{ marginBottom: "4px" }}>
                <span className={classes.extraInfoLabel}>Item:</span>
                <span className={classes.extraInfoValue}>{item}</span>
              </div>
              <div>
                <span className={classes.extraInfoLabel}>Amount:</span>
                <span className={classes.extraInfoValue}>{amount}</span>
              </div>
            </div>
          )
        }
      }

      return (
        <div style={{ width: "100%" }}>
          <span className={classes.extraInfoValue}>{extraInfo}</span>
        </div>
      )
    }

    return (
      <div style={{ width: "100%" }}>
        <span className={classes.extraInfoValue}>{String(extraInfo)}</span>
      </div>
    )
  }

  return (
    <div className={classes.wrapper}>
      {loading ? (
        <p>Loading...</p>
      ) : err ? (
        <Alert severity="error">Unable to fetch admin data</Alert>
      ) : admin ? (
        <>
          <div className={classes.adminInfoContainer}>
            <h3 className={classes.header}>Admin Information</h3>
            <Grid container spacing={3}>
              <Grid item xs={12} md={6}>
                <List>
                  <ListItem>
                    <ListItemText primary="Admin Name" secondary={admin.AdminInfo.Name} />
                  </ListItem>
                  <ListItem>
                    <ListItemText primary="Admin State" secondary={admin.AdminInfo.Status} />
                  </ListItem>
                  <ListItem>
                    <ListItemText primary="Staff Group" secondary={admin.AdminInfo.StaffGroup || "None"} />
                  </ListItem>
                </List>
              </Grid>
              <Grid item xs={12} md={6}>
                <List>
                  <ListItem>
                    <ListItemText primary="Admin Points (AP)" secondary={admin.AdminInfo.AP || "N/A"} />
                  </ListItem>
                  <ListItem>
                    <ListItemText primary="Disconnected" secondary={admin.AdminInfo.Disconnected ? "Yes" : "No"} />
                  </ListItem>
                  {admin.AdminInfo.Disconnected && (
                    <>
                      <ListItem>
                        <ListItemText
                          primary="Last Online"
                          secondary={moment(admin.AdminInfo.DisconnectedTime * 1000).format("LLL")}
                        />
                      </ListItem>
                      <ListItem>
                        <ListItemText primary="Disconnect Reason" secondary={admin.AdminInfo.DisconnectedReason} />
                      </ListItem>
                    </>
                  )}
                </List>
              </Grid>
            </Grid>
          </div>

          <div className={classes.historyContainer}>
            <h3 className={classes.header}>Admin History</h3>
            {admin.AdminInfo.AdminHistory && admin.AdminInfo.AdminHistory.length > 0 ? (
              <TableContainer component={Paper} className={classes.tableContainer}>
                <Table stickyHeader>
                  <TableHead>
                    <TableRow>
                      <TableCell width="50%">Event</TableCell>
                      <TableCell width="40%">Date</TableCell>
                      <TableCell width="10%" align="center">
                        Details
                      </TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {admin.AdminInfo.AdminHistory.map((entry, index) => {
                      const date = entry.DATE || entry.date
                      const event = entry.EVENT || entry.event
                      const extraInfo = entry.EXTRAINFO || entry.extrainfo
                      const isExpanded = expandedItem === index

                      return (
                        <React.Fragment key={index}>
                          <TableRow
                            className={classes.tableRow}
                            onClick={() => extraInfo && handleHistoryItemClick(index)}
                          >
                            <TableCell>
                              <span className={classes.eventText}>{event}</span>
                            </TableCell>
                            <TableCell>
                              <span className={classes.dateText}>{formatDate(date)}</span>
                            </TableCell>
                            <TableCell align="center">
                              {extraInfo && (
                                <IconButton
                                  size="small"
                                  className={`${classes.expandIcon} ${isExpanded ? classes.expandIconRotated : ""}`}
                                >
                                  {isExpanded ? <ExpandLess /> : <ExpandMore />}
                                </IconButton>
                              )}
                            </TableCell>
                          </TableRow>
                          {extraInfo && (
                            <TableRow>
                              <TableCell colSpan={3} padding="none" style={{ padding: 0, border: 0 }}>
                                <Collapse in={isExpanded} timeout="auto" unmountOnExit>
                                  <Box className={classes.extraInfoContainer}>{formatExtraInfo(extraInfo)}</Box>
                                </Collapse>
                              </TableCell>
                            </TableRow>
                          )}
                        </React.Fragment>
                      )
                    })}
                  </TableBody>
                </Table>
              </TableContainer>
            ) : (
              <Alert severity="info">No Admin history available</Alert>
            )}
          </div>
        </>
      ) : (
        <Alert severity="info">No admin data available</Alert>
      )}
    </div>
  )
}